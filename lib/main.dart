import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_news/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:flutter_news/services/background_service.dart';
import 'package:flutter_news/database/news_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService().initialize();
    print('Notifications initialized successfully');
  } catch (e) {
    print('Error initializing notifications: $e');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeBackgroundTasks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> triggerManualNewsSync() async {
    await Workmanager().registerOneOffTask(
      "manualFetch",
      fetchNewsTask,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    print('Manual news sync triggered at ${DateTime.now()}');
  }

  final List<String> _tags = [];
  final database = NewsDatabase();

  @override
  void initState() {
    super.initState();
    _loadTagsFromPrefs();
  }

  Future<void> _loadTagsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tags = prefs.getStringList('news_tags') ?? [];
      print('Loading tags from SharedPreferences: $tags');
      setState(() {
        _tags.clear();
        _tags.addAll(tags);
      });
    } catch (e) {
      print('Error loading tags: $e');
    }
  }

  void _addTag(String tag) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tags = prefs.getStringList('news_tags') ?? [];
      tags.add(tag);
      await prefs.setStringList('news_tags', tags);
      print('Tags saved to SharedPreferences: $tags');

      setState(() {
        _tags.add(tag);
      });

      triggerManualNewsSync();
    } catch (e) {
      print('Error adding tag: $e');
    }
  }

  void _removeTag(String tag) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tags = prefs.getStringList('news_tags') ?? [];
      tags.remove(tag);
      await prefs.setStringList('news_tags', tags);
      print('Tags after removal from SharedPreferences: $tags');

      await database.deleteArticlesByTag(tag);

      setState(() {
        _tags.remove(tag);
      });
    } catch (e) {
      print('Error removing tag: $e');
    }
  }

  void _showAddTagDialog() {
    final TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Tag'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Escreva uma tag"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                _addTag(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _triggerBackgroundFetch() async {
    print('Manually triggering background fetch...');
    await Workmanager().registerOneOffTask(
      "manualFetch",
      fetchNewsTask,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Background fetch triggered')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_tags.isEmpty)
              const Text(
                'Bem vindo ao Flutter News! Adicione tags para receber notificações de noticias.',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeTag(tag),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddTagDialog,
            tooltip: 'Adicionar Tag',
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _triggerBackgroundFetch,
            tooltip: 'Fetch News',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.sync, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
