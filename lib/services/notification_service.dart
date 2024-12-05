import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/news_database.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final NewsDatabase _database = NewsDatabase();

  NotificationService._();

  Future<void> initialize() async {
    const androidChannel = AndroidNotificationChannel(
      'news_channel',
      'News Updates',
      description: 'Notifications for news articles',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

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
    print('Notification tapped: ${response.payload}');

    final payload = response.payload;
    if (payload == null) {
      print('No payload in notification');
      return;
    }

    try {
      final database = NewsDatabase();
      final articles = await database.getUnreadArticles();
      final article = articles.firstWhere((a) => a.url == payload);
      await database.markAsRead(article.id);
      print('Article ${article.id} marked as read');

      final uri = Uri.parse(payload);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      )) {
        print('Could not launch URL: $payload');
      }
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  Future<void> showArticleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'news_channel',
        'News Updates',
        channelDescription: 'Notifications for news articles',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        ongoing: true,
        autoCancel: false,
        styleInformation: BigTextStyleInformation(''),
        category: AndroidNotificationCategory.social,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      final details =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: '$id|$payload',
      );
      print('Article notification shown with channel news_channel');
    } catch (e, stackTrace) {
      print('Error showing article notification: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> requestPermissions() async {
    final ios = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    final android = await Permission.notification.request().isGranted;

    print('iOS notification permission status: $ios');
    print('Android notification permission status: $android');
  }

  Future<void> showSyncErrorNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'sync_error_channel',
        'Sync Error Updates',
        channelDescription: 'Notifications for synchronization errors',
        importance: Importance.high,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        autoCancel: true,
        styleInformation: BigTextStyleInformation(''),
        category: AndroidNotificationCategory.error,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
      );
      print('Sync error notification shown successfully');
    } catch (e) {
      print('Error showing sync error notification: $e');
    }
  }

  Future<void> showSyncNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'sync_channel',
        'Sync Updates',
        channelDescription: 'Notifications for synchronization status',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        autoCancel: true,
        styleInformation: BigTextStyleInformation(''),
        category: AndroidNotificationCategory.progress,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.passive,
      );

      final details =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notifications.show(
        id,
        title,
        body,
        details,
      );
      print('Sync notification shown successfully');
    } catch (e) {
      print('Error showing sync notification: $e');
    }
  }

  Future<void> showLatestNewsNotification() async {
    print('Starting to show notifications...');
    final database = NewsDatabase();

    final unreadArticles = await database.getUnreadArticles();
    print('Found ${unreadArticles.length} unread articles');

    if (unreadArticles.isEmpty) {
      print('No unread articles found, skipping notification');
      return;
    }

    unreadArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    for (var article in unreadArticles) {
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

        print('Notification shown for article: ${article.title}');

        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('Error showing notification: $e');
      }
    }
  }
}
