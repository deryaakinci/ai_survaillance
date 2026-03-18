import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback? onTap;

  const AlertCard({super.key, required this.alert, this.onTap});

  Color get _severityColor {
    switch (alert.severity) {
      case 'high':
        return const Color(0xFFE24B4A);
      case 'medium':
        return const Color(0xFFEF9F27);
      default:
        return const Color(0xFF1D9E75);
    }
  }

  String get _severityLabel {
    switch (alert.severity) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      default:
        return 'Low';
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(alert.timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(color: _severityColor, width: 3),
            top: const BorderSide(color: Color(0xFF222222), width: 0.5),
            right: const BorderSide(color: Color(0xFF222222), width: 0.5),
            bottom: const BorderSide(color: Color(0xFF222222), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: _severityColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.audioLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${alert.zone} · $_timeAgo',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _severityLabel,
                style: TextStyle(
                  fontSize: 9,
                  color: _severityColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}