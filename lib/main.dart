import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  String _data = '';

  @override
  void initState() {
    super.initState();
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
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
      final newsApi = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=${tag}&from=2024-11-03&sortBy=publishedAt&apiKey=ac13a14410f84ef4b9db07d8d91fd617'));
      final newsData = await http.get(Uri.parse('https://newsdata.io/api/1/latest?apikey=pub_6129991685a75dd63079c904f7160050cb879&q=${tag}&region=washington-united%20states%20of%20america'));

      //implementar função de salvar no banco, comparar e mandar notificação.
      //logica newsApi: titulo = jsonDecode(newsApi.body)['articles'][0]['title'] url = jsonDecode(newsData.body)['articles'][0]['url']
      //logica newsData: titulo = jsonDecode(newsData.body)['results'][0]['title'] url = jsonDecode(newsData.body)['results'][0]['link']

      //as requests retornam muitos dados então roda um for pra pegar todos e comparar dps
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