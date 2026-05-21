import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import 'package:intl/intl.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback? onTap;
  final bool showSnapshot;

  const AlertCard({
    super.key,
    required this.alert,
    this.onTap,
    this.showSnapshot = false,
  });

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

  IconData get _severityIcon {
    switch (alert.severity) {
      case 'high':
        return Icons.report_problem_outlined;
      case 'medium':
        return Icons.error_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  static String _fmt(String label) => label
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');

  String get _primaryLabel {
    if (alert.visualLabel != 'normal') return _fmt(alert.visualLabel);
    if (alert.audioLabel != 'normal') return _fmt(alert.audioLabel);
    return 'Normal activity';
  }

  String get _secondaryLine {
    final a = alert.audioLabel != 'normal' ? _fmt(alert.audioLabel) : null;
    final v = alert.visualLabel != 'normal' ? _fmt(alert.visualLabel) : null;
    if (a != null && v != null && a != v) return 'Audio: $a · Visual: $v';
    return '';
  }

  String get _timeAgo {
    final now = DateTime.now();
    final diff = now.difference(alert.timestamp);
    if (diff.inDays == 0 && now.day != alert.timestamp.day) {
      return 'Yesterday';
    }
    if (diff.inHours >= 24) return 'Yesterday';
    return DateFormat('hh:mm a').format(alert.timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF161622),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _severityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _severityIcon,
                          color: _severityColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _primaryLabel,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_secondaryLine.isNotEmpty) ...[
                              Text(
                                _secondaryLine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              '${alert.zone} · $_timeAgo',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888888),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _severityLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: _severityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (showSnapshot) ...[
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: alert.snapshotUrl != null
                              ? Image.network(
                                  'http://127.0.0.1:8000${alert.snapshotUrl}',
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _snapshotPlaceholder(),
                                )
                              : _snapshotPlaceholder(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _snapshotPlaceholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _severityColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.videocam_outlined,
        color: _severityColor.withOpacity(0.4),
        size: 22,
      ),
    );
  }
}