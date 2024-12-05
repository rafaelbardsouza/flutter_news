import 'package:workmanager/workmanager.dart';
import '../database/news_database.dart';
import '../services/notification_service.dart';

const checkUnreadNewsTask = "checkUnreadNewsTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case checkUnreadNewsTask:
          final startTime = DateTime.now();
          print('🕒 [$startTime] Starting background unread news check...');

          final database = NewsDatabase();
          final notificationService = NotificationService();

          final fetchStart = DateTime.now();
          final unreadArticles = await database.getUnreadArticles();
          final fetchEnd = DateTime.now();

          print(
              '⏱️ Database fetch took: ${fetchEnd.difference(fetchStart).inMilliseconds}ms');
          print(
              '📊 Found ${unreadArticles.length} unread articles at ${DateTime.now()}');

          if (unreadArticles.isEmpty) {
            final emptyCheckEnd = DateTime.now();
            print('ℹ️ [$emptyCheckEnd] No unread articles to notify about');
            print(
                '⌛ Total execution time: ${emptyCheckEnd.difference(startTime).inSeconds} seconds');
            return Future.value(true);
          }

          unreadArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

          int notificationsSent = 0;
          final notificationStart = DateTime.now();

          for (var article in unreadArticles) {
            final itemStart = DateTime.now();
            await notificationService.showArticleNotification(
              id: article.id,
              title: 'Nova notícia relacionada a ${article.matchedTag}',
              body: article.title,
              payload: article.url,
            );
            final itemEnd = DateTime.now();

            notificationsSent++;
            print(
                '🔔 [${DateTime.now()}] Notification sent for article ID: ${article.id}');
            print(
                '⏱️ Notification #$notificationsSent took: ${itemEnd.difference(itemStart).inMilliseconds}ms');
          }

          final notificationEnd = DateTime.now();
          final totalDuration = notificationEnd.difference(startTime);

          print('\n📊 Notification Summary:');
          print('🔢 Total notifications sent: $notificationsSent');
          print(
              '⏱️ Total notification time: ${notificationEnd.difference(notificationStart).inSeconds} seconds');
          print('⌛ Total execution time: ${totalDuration.inSeconds} seconds');
          print('✅ [$notificationEnd] Completed unread news check\n');
          break;
      }
      return Future.value(true);
    } catch (err) {
      final errorTime = DateTime.now();
      print('❌ [$errorTime] Background unread news check error: $err');
      return Future.value(false);
    }
  });
}

void initializeUnreadNewsCheck() async {
  await Workmanager().registerPeriodicTask(
    "unreadNewsCheck",
    checkUnreadNewsTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );
  print('🔄 [${DateTime.now()}] Unread news check scheduled');
}
