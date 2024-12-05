import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/news_database.dart';
import '../services/notification_service.dart';

const fetchNewsTask = "fetchNewsTask";
const newsApiKey = "ac13a14410f84ef4b9db07d8d91fd617";
const newsDataKey = "pub_6129991685a75dd63079c904f7160050cb879";

void logNewsArticle(NewsArticle article) {
  print('New article saved to database:');
  print('Title: ${article.title}');
  print('Source: ${article.source}');
  print('Tag: ${article.matchedTag}');
  print('Published: ${article.publishedAt}');
  print('URL: ${article.url}');
  print('-------------------');
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case fetchNewsTask:
          print('Starting background news fetch...');
          final database = NewsDatabase();
          await database.logDatabaseState();

          final prefs = await SharedPreferences.getInstance();
          final tags = prefs.getStringList('news_tags') ?? [];
          print('Fetching news for tags: $tags');

          int totalNewArticles = 0;

          for (String tag in tags) {
            print('\nProcessing tag: $tag');

            final latestArticles = await database.getArticlesByTag(tag);
            DateTime latestTimestamp =
                DateTime.now().subtract(const Duration(days: 1));
            if (latestArticles.isNotEmpty) {
              latestTimestamp = latestArticles
                  .map((article) => article.publishedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b);
              print('Latest article timestamp for $tag: $latestTimestamp');
            }

            try {
              final newsApiResponse = await http.get(
                Uri.parse('https://newsapi.org/v2/top-headlines'
                    '?apiKey=$newsApiKey'
                    '&q=${Uri.encodeComponent(tag)}'
                    '&pageSize=100'
                    '&language=en'),
                headers: {'Authorization': 'Bearer $newsApiKey'},
              );

              if (newsApiResponse.statusCode == 200) {
                final newsApiJson = jsonDecode(newsApiResponse.body);
                if (newsApiJson['status'] == 'ok' &&
                    newsApiJson['articles'] != null) {
                  print(
                      'NewsAPI returned ${newsApiJson['articles'].length} articles');

                  for (var article in newsApiJson['articles']) {
                    if (article['title'] != null &&
                        article['url'] != null &&
                        article['publishedAt'] != null) {
                      try {
                        final publishedAt =
                            DateTime.parse(article['publishedAt']);
                        if (publishedAt.isAfter(latestTimestamp)) {
                          final newsArticle = await database.addNewsArticle(
                            NewsArticlesCompanion.insert(
                              title: article['title'],
                              url: article['url'],
                              source: 'NewsAPI',
                              matchedTag: tag,
                              publishedAt: publishedAt,
                            ),
                          );
                          totalNewArticles++;
                          logNewsArticle(
                              await database.getArticleById(newsArticle));
                        }
                      } catch (e) {
                        print('Error processing NewsAPI article: $e');
                      }
                    }
                  }
                }
              } else {
                print(
                    'NewsAPI error: ${newsApiResponse.statusCode} - ${newsApiResponse.body}');
              }
            } catch (e) {
              print('NewsAPI fetch error: $e');
            }

            try {
              final newsDataResponse = await http.get(
                Uri.parse('https://newsdata.io/api/1/latest'
                    '?apikey=$newsDataKey'
                    '&q=${Uri.encodeComponent(tag)}'
                    '&language=en'),
              );

              if (newsDataResponse.statusCode == 200) {
                final newsDataJson = jsonDecode(newsDataResponse.body);
                if (newsDataJson['status'] == 'success' &&
                    newsDataJson['results'] != null) {
                  print(
                      'NewsData.io returned ${newsDataJson['results'].length} articles');

                  for (var article in newsDataJson['results']) {
                    if (article['title'] != null &&
                        article['link'] != null &&
                        article['pubDate'] != null) {
                      try {
                        final publishedAt = DateTime.parse(article['pubDate']);
                        if (publishedAt.isAfter(latestTimestamp)) {
                          final newsArticle = await database.addNewsArticle(
                            NewsArticlesCompanion.insert(
                              title: article['title'],
                              url: article['link'],
                              source: 'NewsData',
                              matchedTag: tag,
                              publishedAt: publishedAt,
                            ),
                          );
                          totalNewArticles++;
                          logNewsArticle(
                              await database.getArticleById(newsArticle));
                        }
                      } catch (e) {
                        print('Error processing NewsData article: $e');
                      }
                    }
                  }
                }
              } else {
                print(
                    'NewsData.io error: ${newsDataResponse.statusCode} - ${newsDataResponse.body}');
              }
            } catch (e) {
              print('NewsData.io fetch error: $e');
            }
          }

          print('\nBackground fetch completed:');
          await database.logDatabaseState();
          print('Total new articles saved: $totalNewArticles');
          if (totalNewArticles > 0) {
            try {
              final notificationService = NotificationService();
              await notificationService.initialize();
              await notificationService.showLatestNewsNotification();
              print('Notification sent for new articles');
            } catch (e) {
              print('Error showing notification: $e');
              print(e);
            }
          }

          print('====================\n');
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
