import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ShatterOverlay extends StatefulWidget {
  final Widget child;
  final VoidCallback onShatterComplete;

  const ShatterOverlay({
    super.key,
    required this.child,
    required this.onShatterComplete,
  });

  @override
  State<ShatterOverlay> createState() => _ShatterOverlayState();
}

class _ShatterOverlayState extends State<ShatterOverlay> with TickerProviderStateMixin {
  final GlobalKey _boundaryKey = GlobalKey();
  int _tapCount = 0;
  Timer? _resetTimer;
  
  List<Offset> _tapPoints = [];
  bool _isShattering = false;
  ui.Image? _screenSnapshot;
  
  late AnimationController _shatterController;

  @override
  void initState() {
    super.initState();
    _shatterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _shatterController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isShattering) return;

    setState(() {
      _tapCount++;
      _tapPoints.add(details.localPosition);
    });

    // Reset tap count if no tap for 1.5 seconds
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!_isShattering) {
        setState(() {
          _tapCount = 0;
          _tapPoints.clear();
        });
      }
    });

    // Haptic feedback for each crack
    HapticFeedback.mediumImpact();

    if (_tapCount >= 6) {
      _startShatter();
    }
  }

  Future<void> _startShatter() async {
    setState(() {
      _isShattering = true;
    });

    // Capture the screen
    try {
      RenderRepaintBoundary? boundary = 
          _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 1.0);
        setState(() {
          _screenSnapshot = image;
        });
        _shatterController.forward().then((_) {
          widget.onShatterComplete();
          // Reset after a delay
          Future.delayed(const Duration(seconds: 1), () {
             if (mounted) {
                setState(() {
                  _isShattering = false;
                  _tapCount = 0;
                  _tapPoints.clear();
                  _screenSnapshot = null;
                  _shatterController.reset();
                });
             }
          });
        });
      }
    } catch (e) {
      debugPrint("Shatter capture failed: $e");
      widget.onShatterComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      child: Stack(
        children: [
          // The actual content
          RepaintBoundary(
            key: _boundaryKey,
            child: Opacity(
              opacity: _isShattering ? 0.0 : 1.0,
              child: widget.child,
            ),
          ),

          // Crack lines
          if (!_isShattering && _tapPoints.isNotEmpty)
            IgnorePointer(
              child: CustomPaint(
                size: Size.infinite,
                painter: CrackPainter(tapPoints: _tapPoints, tapCount: _tapCount),
              ),
            ),

          // Shattered shards
          if (_isShattering && _screenSnapshot != null)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _shatterController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: ShatterPainter(
                      image: _screenSnapshot!,
                      progress: _shatterController.value,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CrackPainter extends CustomPainter {
  final List<Offset> tapPoints;
  final int tapCount;

  CrackPainter({required this.tapPoints, required this.tapCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 + (tapCount * 0.1).clamp(0, 0.6))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final random = math.Random(42); // Seeded for consistency

    for (var point in tapPoints) {
      // Draw 5-8 random jagged lines from each tap point
      int lines = 5 + random.nextInt(4);
      for (int i = 0; i < lines; i++) {
        double angle = (i * (360 / lines) + random.nextDouble() * 20) * (math.pi / 180);
        Offset current = point;
        double length = 20.0 + random.nextDouble() * 40.0 * tapCount;
        
        Path path = Path()..moveTo(current.dx, current.dy);
        
        // Make it jagged
        int segments = 3 + random.nextInt(3);
        for (int j = 0; j < segments; j++) {
            double segmentLength = length / segments;
            double jitterAngle = angle + (random.nextDouble() - 0.5) * 0.5;
            current += Offset(math.cos(jitterAngle), math.sin(jitterAngle)) * segmentLength;
            path.lineTo(current.dx, current.dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CrackPainter oldDelegate) => true;
}

class ShatterPainter extends CustomPainter {
  final ui.Image image;
  final double progress;
  late List<Shard> _shards;

  ShatterPainter({required this.image, required this.progress}) {
    _shards = _generateShards(Size(image.width.toDouble(), image.height.toDouble()));
  }

  List<Shard> _generateShards(Size size) {
    final List<Shard> shards = [];
    final int rows = 8;
    final int cols = 6;
    final double w = size.width / cols;
    final double h = size.height / rows;
    final random = math.Random(123);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        // Create 2 triangles per grid cell for a shattered look
        Offset p1 = Offset(j * w, i * h);
        Offset p2 = Offset((j + 1) * w, i * h);
        Offset p3 = Offset(j * w, (i + 1) * h);
        Offset p4 = Offset((j + 1) * w, (i + 1) * h);

        // Randomize vertices slightly
        p1 += Offset(random.nextDouble() * 10 - 5, random.nextDouble() * 10 - 5);
        p2 += Offset(random.nextDouble() * 10 - 5, random.nextDouble() * 10 - 5);
        p3 += Offset(random.nextDouble() * 10 - 5, random.nextDouble() * 10 - 5);
        p4 += Offset(random.nextDouble() * 10 - 5, random.nextDouble() * 10 - 5);

        shards.add(Shard([p1, p2, p3], random));
        shards.add(Shard([p2, p3, p4], random));
      }
    }
    return shards;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var shard in _shards) {
      shard.draw(canvas, image, progress);
    }
  }

  @override
  bool shouldRepaint(covariant ShatterPainter oldDelegate) => true;
}

class Shard {
  final List<Offset> vertices;
  final double velocityX;
  final double velocityY;
  final double rotationVelocity;
  final Offset center;

  Shard(this.vertices, math.Random rand)
      : velocityX = (rand.nextDouble() - 0.5) * 800,
        velocityY = (rand.nextDouble() * 1200) - 400,
        rotationVelocity = (rand.nextDouble() - 0.5) * 10,
        center = Offset(
          (vertices[0].dx + vertices[1].dx + vertices[2].dx) / 3,
          (vertices[0].dy + vertices[1].dy + vertices[2].dy) / 3,
        );

  void draw(Canvas canvas, ui.Image image, double progress) {
    if (progress <= 0) return;

    final double t = progress;
    // Simple projectile motion with gravity
    double x = center.dx + velocityX * t;
    double y = center.dy + velocityY * t + 0.5 * 2000 * t * t; // gravity
    double rotation = rotationVelocity * t;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    // Clip to triangle
    Path path = Path()
      ..moveTo(vertices[0].dx, vertices[0].dy)
      ..lineTo(vertices[1].dx, vertices[1].dy)
      ..lineTo(vertices[2].dx, vertices[2].dy)
      ..close();
    
    canvas.clipPath(path);
    
    // Draw the image piece
    canvas.drawImage(image, Offset.zero, Paint());
    
    // Slight white border for "glass" effect
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.1)..style = PaintingStyle.stroke..strokeWidth = 0.5);

    canvas.restore();
  }
}
