import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_news/services/background_service.dart';
import 'package:flutter_news/database/news_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

      _getNews([tag]);
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

      final database = NewsDatabase();
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

  void _getNews(List<String> tags) async {
    for (String tag in tags) {
      try {
        final newsApi = await http.get(Uri.parse(
            'https://newsapi.org/v2/top-headlines?apiKey=ac13a14410f84ef4b9db07d8d91fd617&q=$tag&pageSize=100'));

        final newsData = await http.get(Uri.parse(
            'https://newsdata.io/api/1/latest?apikey=pub_6129991685a75dd63079c904f7160050cb879&q=${tag}'
            // 'https://newsdata.io/api/1/latest?apikey=pub_6129991685a75dd63079c904f7160050cb879&q=${tag}&region=washington-united%20states%20of%20america'
            ));

        final newsApiJson = jsonDecode(newsApi.body);
        print('NewsAPI Response for tag $tag:');
        print('Status: ${newsApiJson['status']}');
        if (newsApiJson['articles'] != null &&
            newsApiJson['articles'].isNotEmpty) {
          print('First article example:');
          print('Title: ${newsApiJson['articles'][0]['title']}');
          print('URL: ${newsApiJson['articles'][0]['url']}');
          print('Published At: ${newsApiJson['articles'][0]['publishedAt']}');
          print('Total articles: ${newsApiJson['articles'].length}');
        }

        final newsDataJson = jsonDecode(newsData.body);
        print('\nNewsData Response for tag $tag:');
        print('Status: ${newsDataJson['status']}');
        if (newsDataJson['results'] != null &&
            newsDataJson['results'].isNotEmpty) {
          print('First article example:');
          print('Title: ${newsDataJson['results'][0]['title']}');
          print('URL: ${newsDataJson['results'][0]['link']}');
          print('Published At: ${newsDataJson['results'][0]['pubDate']}');
          print('Total results: ${newsDataJson['results'].length}');
        }

        print('\n-------------------\n');
      } catch (e) {
        print('Error fetching news for tag $tag: $e');
      }
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTagDialog,
        tooltip: 'Adicionar Tag',
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
