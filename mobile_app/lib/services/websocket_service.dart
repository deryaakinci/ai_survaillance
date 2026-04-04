import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/alert_model.dart';
import 'notification_service.dart';
import 'secure_storage_service.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool isConnected = false;
  AlertModel? latestAlert;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  final NotificationService _notificationService = NotificationService();
  final SecureStorageService _storage = SecureStorageService();
  final List<VoidCallback> _onAlertCallbacks = [];

  void addAlertListener(VoidCallback callback) {
    _onAlertCallbacks.add(callback);
  }

  void removeAlertListener(VoidCallback callback) {
    _onAlertCallbacks.remove(callback);
  }

  Future<void> connect() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();
    _connect();
  }

  Future<void> _connect() async {
    try {
      final userId = await _storage.getUserId() ?? '1';

      _channel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8000/ws/$userId'),
      );

      isConnected = true;
      notifyListeners();

      _pingTimer?.cancel();
      _pingTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) {
          try {
            _channel?.sink.add('ping');
          } catch (_) {}
        },
      );

      _channel!.stream.listen(
        (message) => _handleMessage(message),
        onDone: () => _onDisconnected(),
        onError: (_) => _onDisconnected(),
      );
    } catch (e) {
      _onDisconnected();
    }
  }

  void _onDisconnected() {
    isConnected = false;
    _pingTimer?.cancel();
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      const Duration(seconds: 5),
      () => _connect(),
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final data = json.decode(message.toString());
      final type = data['type'];

      if (type == 'alert') {
        final alertData = data['data'];
        latestAlert = AlertModel(
          id: alertData['id'] ?? '',
          audioLabel: alertData['audio_label'] ?? '',
          visualLabel: alertData['visual_label'] ?? '',
          zone: alertData['zone'] ?? 'Zone 1',
          severity: alertData['severity'] ?? 'low',
          timestamp: DateTime.tryParse(
                alertData['timestamp'] ?? '',
              ) ??
              DateTime.now(),
        );

        _notificationService.showAlertNotification(latestAlert!);

        for (final callback in _onAlertCallbacks) {
          callback();
        }

        notifyListeners();
      }

      if (type == 'sensor_status') {
        final statusData = data['data'];
        if (statusData['audio_online'] == false) {
          _notificationService
              .showSensorOfflineNotification('Audio sensor');
        }
        if (statusData['visual_online'] == false) {
          _notificationService
              .showSensorOfflineNotification('Visual sensor');
        }
        notifyListeners();
      }
    } catch (e) {
      print('WebSocket message error: $e');
    }
  }

  void disconnect() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}