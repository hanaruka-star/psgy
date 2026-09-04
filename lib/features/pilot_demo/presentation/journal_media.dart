import 'dart:io';

import 'package:flutter/material.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';

bool journalHasMedia(JournalPost post) {
  final url = post.mediaUrl;
  if (url == null || url.isEmpty) return false;
  if (url.startsWith('assets/') || url.startsWith('http')) return true;
  return File(url).existsSync();
}

Widget journalMediaImage(
  String url, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (url.startsWith('assets/')) {
    return Image.asset(url, fit: fit, width: width, height: height);
  }
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return Image.network(url, fit: fit, width: width, height: height);
  }
  return Image.file(File(url), fit: fit, width: width, height: height);
}
