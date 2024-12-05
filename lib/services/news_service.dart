import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/news_database.dart';
import '../services/notification_service.dart';

class NewsService {
  static final NewsService instance = NewsService._();
  factory NewsService() => instance;
  NewsService._();

  Future<void> fetchAndProcessNews(List<String> tags) async {
    final database = NewsDatabase();
    final notificationService = NotificationService();
    int totalArticlesSaved = 0;
    bool hasErrors = false;
    String errorDetails = '';

    for (String tag in tags) {
      try {
        final newsApi = await http.get(Uri.parse(
            'https://newsapi.org/v2/everything?q=$tag&from=2024-11-03&sortBy=publishedAt&apiKey=ac13a14410f84ef4b9db07d8d91fd617'));

        final newsData = await http.get(Uri.parse(
            'https://newsdata.io/api/1/latest?apikey=pub_6129991685a75dd63079c904f7160050cb879&q=$tag&region=washington-united%20states%20of%20america'));

        final newsApiJson = jsonDecode(newsApi.body);
        if (newsApiJson['status'] == 'ok' && newsApiJson['articles'] != null) {
          final articles = newsApiJson['articles'] as List;
          for (var article in articles) {
            await database.addNewsArticle(
              NewsArticlesCompanion.insert(
                title: article['title'] ?? 'No title',
                url: article['url'] ?? '',
                source: 'newsapi',
                matchedTag: tag,
                publishedAt: DateTime.parse(
                    article['publishedAt'] ?? DateTime.now().toIso8601String()),
              ),
            );
            totalArticlesSaved++;
          }
          print('Saved ${articles.length} articles from NewsAPI for tag: $tag');
        } else {
          print(
              'NewsAPI error or no articles: ${newsApiJson['status']} - ${newsApiJson['message']}');
          hasErrors = true;
          errorDetails +=
              'NewsAPI: ${newsApiJson['message'] ?? 'Unknown error'}\n';
        }

        final newsDataJson = jsonDecode(newsData.body);
        if (newsDataJson['status'] == 'success' &&
            newsDataJson['results'] != null) {
          final articles = newsDataJson['results'] as List;
          for (var article in articles) {
            await database.addNewsArticle(
              NewsArticlesCompanion.insert(
                title: article['title'] ?? 'No title',
                url: article['link'] ?? '',
                source: 'newsdata',
                matchedTag: tag,
                publishedAt: DateTime.parse(
                    article['pubDate'] ?? DateTime.now().toIso8601String()),
              ),
            );
            totalArticlesSaved++;
          }
          print(
              'Saved ${articles.length} articles from NewsData for tag: $tag');
        } else {
          print(
              'NewsData error or no results: ${newsDataJson['status']} - ${newsDataJson['message']}');
          hasErrors = true;
          errorDetails +=
              'NewsData: ${newsDataJson['message'] ?? 'Unknown error'}\n';
        }
      } catch (e, stackTrace) {
        print('Error fetching/processing news for tag $tag:');
        print('Error: $e');
        print('Stack trace: $stackTrace');
        hasErrors = true;
        errorDetails += 'Tag $tag: $e\n';
      }
    }

    // Show sync completion notification
    if (totalArticlesSaved > 0) {
      await notificationService.showSyncNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Sincronização Concluída',
        body: 'Foram encontrados $totalArticlesSaved novos artigos.',
      );
    }

    // Show error notification if there were any issues
    if (hasErrors) {
      await notificationService.showSyncErrorNotification(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        title: 'Problemas na Sincronização',
        body: 'Ocorreram alguns erros durante a sincronização:\n$errorDetails',
      );
    }
  }
}
