import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/news_database.dart';

const fetchNewsTask = "fetchNewsTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case fetchNewsTask:
          final prefs = await SharedPreferences.getInstance();
          final tags = prefs.getStringList('news_tags') ?? [];
          final database = NewsDatabase();

          for (String tag in tags) {
            final latestArticles = await database.getArticlesByTag(tag);
            DateTime latestTimestamp =
                DateTime.now().subtract(const Duration(days: 1));
            if (latestArticles.isNotEmpty) {
              latestTimestamp = latestArticles
                  .map((article) => article.publishedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b);
            }

            try {
              final newsApiResponse =
                  await http.get(Uri.parse('https://newsapi.org/v2/everything?'
                      'q=$tag&'
                      'from=${latestTimestamp.toIso8601String()}&'
                      'sortBy=publishedAt&'
                      'apiKey=YOUR_API_KEY'));

              if (newsApiResponse.statusCode == 200) {
                final newsApiJson = jsonDecode(newsApiResponse.body);
                if (newsApiJson['status'] == 'ok' &&
                    newsApiJson['articles'] != null) {
                  for (var article in newsApiJson['articles']) {
                    final publishedAt = DateTime.parse(article['publishedAt']);
                    if (publishedAt.isAfter(latestTimestamp)) {
                      await database.addNewsArticle(
                        NewsArticlesCompanion.insert(
                          title: article['title'] ?? 'No title',
                          url: article['url'] ?? '',
                          source: 'newsapi',
                          matchedTag: tag,
                          publishedAt: publishedAt,
                        ),
                      );
                    }
                  }
                }
              }

              final newsDataResponse =
                  await http.get(Uri.parse('https://newsdata.io/api/1/latest?'
                      'apikey=YOUR_API_KEY&'
                      'q=$tag&'
                      'language=en'));

              if (newsDataResponse.statusCode == 200) {
                final newsDataJson = jsonDecode(newsDataResponse.body);
                if (newsDataJson['status'] == 'success' &&
                    newsDataJson['results'] != null) {
                  for (var article in newsDataJson['results']) {
                    final publishedAt = DateTime.parse(article['pubDate']);
                    if (publishedAt.isAfter(latestTimestamp)) {
                      await database.addNewsArticle(
                        NewsArticlesCompanion.insert(
                          title: article['title'] ?? 'No title',
                          url: article['link'] ?? '',
                          source: 'newsdata',
                          matchedTag: tag,
                          publishedAt: publishedAt,
                        ),
                      );
                    }
                  }
                }
              }
            } catch (e) {
              print('Error fetching news for tag $tag: $e');
            }
          }
          break;
      }
      return Future.value(true);
    } catch (err) {
      print('Background task error: $err');
      return Future.value(false);
    }
  });
}

void initializeBackgroundTasks() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "1",
    fetchNewsTask,
    frequency: const Duration(minutes: 30),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
