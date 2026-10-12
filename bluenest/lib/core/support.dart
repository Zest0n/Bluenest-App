import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Contact Support" button -> opens the device's email app.
class SupportMailer {
  /// TODO: replace with the real support address.
  static const String supportEmail = 'support@bluenest.app';

  static Future<void> open(
    BuildContext context, {
    String subject = 'BlueNest Support',
  }) async {
    final uri = Uri.parse(
        'mailto:$supportEmail?subject=${Uri.encodeComponent(subject)}');
    bool opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {}
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email app found on this device')),
      );
    }
  }
}
