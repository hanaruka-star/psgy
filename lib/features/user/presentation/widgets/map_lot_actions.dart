import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLotDirections({
  required BuildContext context,
  required double lat,
  required double lng,
}) async {
  final urls = [
    Uri.parse('comgooglemaps://?daddr=$lat,$lng&directionsmode=driving'),
    Uri.parse('maps://?daddr=$lat,$lng'),
    Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
  ];

  for (final url in urls) {
    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {}
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Không thể mở ứng dụng bản đồ')),
  );
}

Future<void> openLotImage({
  required BuildContext context,
  required String? photoUrl,
  required String lotName,
}) async {
  final trimmedUrl = photoUrl?.trim();
  if (trimmedUrl == null || trimmedUrl.isEmpty) {
    if (!context.mounted) return;
    await _showImageErrorDialog(
      context: context,
      message: 'Chưa có hình ảnh cho $lotName',
    );
    return;
  }

  try {
    if (!context.mounted) return;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _LotPhotoViewerScreen(
          lotName: lotName,
          rawImageField: trimmedUrl,
        ),
      ),
    );
  } catch (_) {
    if (!context.mounted) return;
    await _showImageErrorDialog(
      context: context,
      message: 'Không thể mở ảnh cho $lotName',
    );
  }
}

class _LotPhotoViewerScreen extends StatefulWidget {
  final String lotName;
  final String rawImageField;

  const _LotPhotoViewerScreen({
    required this.lotName,
    required this.rawImageField,
  });

  @override
  State<_LotPhotoViewerScreen> createState() => _LotPhotoViewerScreenState();
}

class _LotPhotoViewerScreenState extends State<_LotPhotoViewerScreen> {
  late final Future<List<String>> _resolvedUrlsFuture =
      _resolveImageUrls(widget.rawImageField);
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.lotName,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _resolvedUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final urls = snapshot.data ?? const <String>[];
          if (urls.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Không tải được ảnh cho bãi này.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          if (urls.length == 1) {
            return _ZoomableNetworkImage(url: urls.first);
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: urls.length,
                onPageChanged: (index) {
                  setState(() => _pageIndex = index);
                },
                itemBuilder: (_, index) {
                  return _ZoomableNetworkImage(url: urls[index]);
                },
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_pageIndex + 1}/${urls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ZoomableNetworkImage extends StatelessWidget {
  final String url;

  const _ZoomableNetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
          errorBuilder: (_, __, ___) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Ảnh tải lỗi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<String>> _resolveImageUrls(String rawImageField) async {
  final candidates = _extractImageCandidates(rawImageField);
  final resolved = <String>[];

  for (final candidate in candidates) {
    final url = await _resolveImageCandidate(candidate);
    if (url != null && url.isNotEmpty && !resolved.contains(url)) {
      resolved.add(url);
    }
  }

  return resolved;
}

List<String> _extractImageCandidates(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return const <String>[];

  if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
    try {
      final parsed = jsonDecode(trimmed);
      if (parsed is List) {
        return parsed
            .whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);
      }
    } catch (_) {}
  }

  final split = trimmed
      .split(RegExp(r'[\n,;|]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);
  if (split.isNotEmpty) return split;

  return <String>[trimmed];
}

Future<String?> _resolveImageCandidate(String candidate) async {
  final lowered = candidate.toLowerCase();
  if (lowered.startsWith('http://') || lowered.startsWith('https://')) {
    return candidate;
  }

  if (candidate.startsWith('gs://')) {
    try {
      return FirebaseStorage.instance.refFromURL(candidate).getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  try {
    final uri = Uri.tryParse(candidate);
    if (uri != null && uri.scheme.isNotEmpty) {
      return null;
    }

    if (candidate.contains('/')) {
      return FirebaseStorage.instance.ref(candidate).getDownloadURL();
    }
  } catch (_) {
    return null;
  }

  return null;
}

Future<void> _showImageErrorDialog({
  required BuildContext context,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Không mở được ảnh'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext, rootNavigator: true).pop(),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}
