import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/news_database.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _onNotificationTapped(NotificationResponse response) async {
    if (response.payload != null) {
      final url = Uri.parse(response.payload!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> showLatestNewsNotification() async {
    print('Starting to show notification...');
    final database = NewsDatabase();
    final prefs = await SharedPreferences.getInstance();

    final unreadArticles = await database.getUnreadArticles();
    print('Found ${unreadArticles.length} unread articles');

    if (unreadArticles.isEmpty) {
      print('No unread articles found, skipping notification');
      return;
    }

    unreadArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    final article = unreadArticles.first;

    final lastNotifiedTime = prefs.getInt('last_notification_timestamp') ?? 0;

    if (article.publishedAt.millisecondsSinceEpoch > lastNotifiedTime) {
      print('Showing notification for article: ${article.title}');

      try {
        await _notifications.show(
          article.id,
          'Nova notícia: ${article.matchedTag}',
          article.title,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'news_channel',
              'News Updates',
              channelDescription: 'Notifications for new articles',
              importance: Importance.high,
              priority: Priority.high,
              enableLights: true,
              enableVibration: true,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: article.url,
        );

        await prefs.setInt('last_notification_timestamp',
            article.publishedAt.millisecondsSinceEpoch);

        print('Notification shown successfully');
      } catch (e) {
        print('Error showing notification: $e');
        print(e);
      }
    } else {
      print('No newer articles since last notification');
    }
  }
}
