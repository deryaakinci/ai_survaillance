import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alert_model.dart';

class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    final IOSFlutterLocalNotificationsPlugin? iosPlugin =
        _plugin.resolvePlatformSpecificImplementation();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showAlertNotification(AlertModel alert) async {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: alert.severity == 'high' ? 'default' : null,
    );

    final details = NotificationDetails(iOS: iosDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      _getTitle(alert),
      _getBody(alert),
      details,
    );
  }

  Future<void> showSensorOfflineNotification(String sensor) async {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      0,
      '⚠️ Sensor offline',
      '$sensor has gone offline — system in degraded mode',
      NotificationDetails(iOS: iosDetails),
    );
  }

  Future<void> clearAll() async {
    await _plugin.cancelAll();
  }

  String _getTitle(AlertModel alert) {
    final prefix = alert.severity == 'high' ? '🚨' : '⚠️';
    final titles = {
      'gunshot': 'Gunshot detected',
      'explosion': 'Explosion detected',
      'scream': 'Scream detected',
      'glass_break': 'Glass break detected',
      'break_in': 'Break-in attempt',
      'door_forced': 'Door being forced',
      'crying_distress': 'Distress detected',
      'fight_sounds': 'Fight detected',
      'siren': 'Emergency siren nearby',
      'car_crash': 'Car crash detected',
      'threatening_voice': 'Threatening voice detected',
    };
    return '$prefix ${titles[alert.audioLabel] ?? 'Alert detected'}';
  }

  String _getBody(AlertModel alert) {
    return '${alert.audioLabel.replaceAll('_', ' ')} · '
        '${alert.visualLabel.replaceAll('_', ' ')} · '
        '${alert.zone}';
  }
}