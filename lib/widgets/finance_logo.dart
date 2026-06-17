import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom Finance AI logo — shield with circuit brain, bar chart, gold arrow & sparkles.
/// Pass showText: true to render the "FINANCE AI" gradient title below the shield.
class FinanceAILogo extends StatelessWidget {
  final double size;
  final bool showText;

  const FinanceAILogo({
    Key? key,
    this.size = 120,
    this.showText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double shieldW = size;
    final double shieldH = size * 1.08;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Shield ──────────────────────────────────────────────────────────
        Container(
          width: shieldW,
          height: shieldH,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2979FF).withOpacity(0.65),
                blurRadius: size * 0.32,
                spreadRadius: size * 0.02,
              ),
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.25),
                blurRadius: size * 0.18,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Shield body (painted)
              CustomPaint(
                size: Size(shieldW, shieldH),
                painter: _ShieldPainter(),
              ),

              // ── Brain (left half) ─────────────────────────────────────────
              Positioned(
                left: shieldW * 0.02,
                top: shieldH * 0.16,
                width: shieldW * 0.52,
                height: shieldH * 0.52,
                child: Center(
                  child: Icon(
                    Icons.psychology_rounded,
                    color: const Color(0xFFFFD54F),
                    size: size * 0.37,
                  ),
                ),
              ),

              // ── Bar chart (right half) ────────────────────────────────────
              Positioned(
                right: shieldW * 0.0,
                top: shieldH * 0.2,
                width: shieldW * 0.52,
                height: shieldH * 0.48,
                child: Center(
                  child: Icon(
                    Icons.bar_chart_rounded,
                    color: const Color(0xFF64B5F6),
                    size: size * 0.35,
                  ),
                ),
              ),

              // ── Gold diagonal arrow ───────────────────────────────────────
              Positioned(
                left: shieldW * 0.22,
                top: shieldH * 0.2,
                child: Transform.rotate(
                  angle: -math.pi / 5.5,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: const Color(0xFFFFD54F),
                    size: size * 0.4,
                  ),
                ),
              ),

              // ── Sparkle particles ─────────────────────────────────────────
              _sparkle(shieldW * 0.02, shieldH * 0.06, size * 0.065),
              _sparkle(shieldW * 0.87, shieldH * 0.04, size * 0.055),
              _sparkle(shieldW * 0.93, shieldH * 0.38, size * 0.045),
              _sparkle(shieldW * 0.04, shieldH * 0.62, size * 0.045),
              _sparkle(shieldW * 0.86, shieldH * 0.68, size * 0.055),
              _sparkle(shieldW * 0.47, shieldH * 0.01, size * 0.04),
            ],
          ),
        ),

        // ── "FINANCE AI" text (optional) ────────────────────────────────────
        if (showText) ...[
          SizedBox(height: size * 0.12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF82B1FF), Color(0xFFFFFFFF), Color(0xFF82B1FF)],
            ).createShader(bounds),
            child: Text(
              'FINANCE AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.22,
                fontWeight: FontWeight.bold,
                letterSpacing: size * 0.05,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _sparkle(double left, double top, double iconSize) {
    return Positioned(
      left: left,
      top: top,
      child: Icon(
        Icons.star_rounded,
        color: const Color(0xFF82B1FF).withOpacity(0.85),
        size: iconSize,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Shield CustomPainter
// ────────────────────────────────────────────────────────────────────────────

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = _buildPath(w, h);

    // 1. Deep dark fill
    canvas.drawPath(path, Paint()..color = const Color(0xFF060D1C));

    // 2. Subtle inner radial tint (gives depth)
    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.topCenter,
          radius: 0.9,
          colors: const [Color(0xFF0D2552), Color(0xFF060D1C)],
        ).createShader(Offset.zero & size),
    );

    // 3. Gradient outer border (bright top → deeper bottom = 3-D look)
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF82B1FF),
            Color(0xFF2979FF),
            Color(0xFF1565C0),
          ],
        ).createShader(Offset.zero & size),
    );

    // 4. Thin inner highlight (glass edge)
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = const Color(0xFFBBDEFB).withOpacity(0.55),
    );

    // 5. Vertical centre divider between brain and chart
    canvas.drawLine(
      Offset(w * 0.5, h * 0.13),
      Offset(w * 0.5, h * 0.85),
      Paint()
        ..color = const Color(0xFF2979FF).withOpacity(0.35)
        ..strokeWidth = 0.8,
    );
  }

  Path _buildPath(double w, double h) {
    final path = Path();
    path.moveTo(w * 0.13, 0);
    path.lineTo(w * 0.87, 0);
    path.quadraticBezierTo(w, 0, w, h * 0.13);
    path.lineTo(w, h * 0.52);
    path.cubicTo(w, h * 0.73, w * 0.68, h * 0.91, w * 0.5, h);
    path.cubicTo(w * 0.32, h * 0.91, 0, h * 0.73, 0, h * 0.52);
    path.lineTo(0, h * 0.13);
    path.quadraticBezierTo(0, 0, w * 0.13, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
