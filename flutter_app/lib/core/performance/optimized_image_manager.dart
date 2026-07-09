import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Optimized image caching and loading system
class OptimizedImageManager {
  static OptimizedImageManager? _instance;
  static OptimizedImageManager get instance => _instance ??= OptimizedImageManager._();
  
  OptimizedImageManager._() {
    _initializeImageCache();
  }

  final Map<String, ui.Image> _memoryCache = {};
  final Map<String, Completer<ui.Image>> _loadingCache = {};
  static const int _maxCacheSize = 100;

  void _initializeImageCache() {
    // Increase Flutter's default cache size for production
    PaintingBinding.instance.imageCache.maximumSize = 200;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100MB
  }

  /// Load image with memory caching and error handling
  Future<ui.Image?> loadImage(String url, {int? maxWidth, int? maxHeight}) async {
    final timer = OperationTimer('ImageLoad:$url');
    
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(url)) {
        timer.end();
        return _memoryCache[url];
      }

      // Check if already loading
      if (_loadingCache.containsKey(url)) {
        final image = await _loadingCache[url]!.future;
        timer.end();
        return image;
      }

      // Load image with isolate
      final completer = Completer<ui.Image>();
      _loadingCache[url] = completer;
      
      final image = await _loadImageIsolate(url, maxWidth, maxHeight);
      
      if (image != null) {
        _cacheImage(url, image);
        completer.complete(image);
      } else {
        completer.completeError('Failed to load image');
      }
      
      _loadingCache.remove(url);
      timer.end();
      return image;
    } catch (e) {
      timer.end();
      developer.log('❌ Failed to load image: $url', error: e, name: 'ImageManager');
      
      // CRITICAL: Complete with error if we have a pending completer to avoid deadlock
      final pending = _loadingCache.remove(url);
      if (pending != null && !pending.isCompleted) {
        pending.completeError(e);
      }
      return null;
    }
  }

  /// Load image with proper error handling and timeout
  Future<ui.Image?> _loadImageIsolate(String url, int? maxWidth, int? maxHeight) async {
    try {
      final completer = Completer<ui.Image>();
      
      // Use network image with proper error handling
      final imageProvider = NetworkImage(url);
      final imageStream = imageProvider.resolve(const ImageConfiguration());
      
      ImageStreamListener? listener;
      
      // Set a timeout for image loading
      final timeoutTimer = Timer(const Duration(seconds: 15), () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Image load timed out', const Duration(seconds: 15)));
        }
      });

      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          timeoutTimer.cancel();
          if (!completer.isCompleted) {
            completer.complete(info.image);
          }
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          timeoutTimer.cancel();
          if (!completer.isCompleted) {
            completer.completeError(exception, stackTrace);
          }
        },
      );
      
      imageStream.addListener(listener);
      
      try {
        final image = await completer.future;
        return image;
      } finally {
        if (listener != null) {
          imageStream.removeListener(listener);
        }
      }
    } catch (e) {
      developer.log('❌ Error in _loadImageIsolate: $e', name: 'ImageManager');
      return null;
    }
  }

  void _cacheImage(String url, ui.Image image) {
    // Manage cache size
    if (_memoryCache.length >= _maxCacheSize) {
      _evictOldestEntry();
    }
    
    _memoryCache[url] = image;
  }

  void _evictOldestEntry() {
    if (_memoryCache.isNotEmpty) {
      final firstKey = _memoryCache.keys.first;
      _memoryCache.remove(firstKey);
    }
  }

  void clearCache() {
    _memoryCache.clear();
    _loadingCache.clear();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Preload critical images for smooth navigation
  Future<void> preloadImages(List<String> urls) async {
    final timer = OperationTimer('PreloadImages');
    
    await Future.wait(
      urls.map((url) => loadImage(url)),
      eagerError: true, // Continue even if some fail
    );
    
    timer.end();
  }
}

/// Widget for optimized image display with placeholder and error handling
class OptimizedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;
  final bool enableCache;
  
  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(color: Colors.grey),
    ),
    this.errorWidget = const Icon(Icons.error, color: Colors.grey),
    this.enableCache = true,
  });

  @override
  State<OptimizedNetworkImage> createState() => _OptimizedNetworkImageState();
}

class _OptimizedNetworkImageState extends State<OptimizedNetworkImage> {
  ui.Image? _cachedImage;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(OptimizedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!widget.enableCache) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final image = await OptimizedImageManager.instance.loadImage(
      widget.imageUrl,
      maxWidth: widget.width?.toInt(),
      maxHeight: widget.height?.toInt(),
    );

    if (mounted) {
      setState(() {
        _cachedImage = image;
        _isLoading = false;
        _hasError = image == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(child: widget.placeholder),
      );
    }

    if (_hasError || _cachedImage == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(child: widget.errorWidget),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RawImage(
        image: _cachedImage,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: Alignment.center,
      ),
    );
  }
}



/// Operation timer for performance tracking
class OperationTimer {
  final String operation;
  final Stopwatch _stopwatch = Stopwatch();
  
  OperationTimer(this.operation) {
    _stopwatch.start();
  }
  
  void end() {
    _stopwatch.stop();
    final ms = _stopwatch.elapsedMilliseconds;
    
    if (ms > 100) {
      developer.log(
        '⚠️ Slow operation: $operation took ${ms}ms',
        name: 'Performance',
        level: ms > 500 ? 1000 : 900,
      );
    }
  }
}