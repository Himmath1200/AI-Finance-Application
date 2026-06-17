import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_finance_platform/utils/index.dart';
import 'package:ai_finance_platform/widgets/finance_logo.dart';

/// Full-screen or inline loading indicator — optionally shows the Finance AI logo with spinning ring
class LoadingIndicator extends StatefulWidget {
  final String? message;
  final bool showLogo;
  final double logoSize;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.showLogo = false,
    this.logoSize = 64,
  }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ring;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ring.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showLogo) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _ring,
            builder: (context, child) {
              final s = widget.logoSize + 48;
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: s,
                    height: s,
                    child: Transform.rotate(
                      angle: _ring.value * 2 * math.pi,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2979FF)),
                        backgroundColor:
                            const Color(0xFF2979FF).withOpacity(0.08),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: s - 14,
                    height: s - 14,
                    child: Transform.rotate(
                      angle: (_ring.value + 0.5) * 2 * math.pi,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        value: 0.25,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFD54F)),
                        backgroundColor: Colors.transparent,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  child!,
                ],
              );
            },
            child: FinanceAILogo(size: widget.logoSize),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 20),
            Text(
              widget.message!,
              style: const TextStyle(
                color: Color(0xFF8BA3C9),
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2979FF)),
            backgroundColor: const Color(0xFF2979FF).withOpacity(0.12),
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 14),
          Text(
            widget.message!,
            style: const TextStyle(color: Color(0xFF8BA3C9), fontSize: 13),
          ),
        ],
      ],
    );
  }
}

/// Dark-styled empty state
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1E3C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1A3A6B)),
              ),
              child: Icon(icon, size: 44, color: const Color(0xFF2979FF)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFF8BA3C9),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded,
                    color: Color(0xFF2979FF), size: 18),
                label: const Text(
                  'Try Again',
                  style: TextStyle(color: Color(0xFF2979FF)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Dark-styled error widget (named AppErrorWidget to avoid shadowing Flutter's ErrorWidget)
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A0D0D),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFCF6679).withOpacity(0.4)),
              ),
              child: const Icon(Icons.error_outline_rounded,
                  size: 44, color: Color(0xFFCF6679)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                  color: Color(0xFF8BA3C9), fontSize: 13, height: 1.5),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded,
                    color: Color(0xFFCF6679), size: 18),
                label: const Text('Retry',
                    style: TextStyle(color: Color(0xFFCF6679))),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton shimmer placeholder (dark)
class ShimmerLoader extends StatefulWidget {
  final int itemCount;
  final double height;

  const ShimmerLoader({
    Key? key,
    this.itemCount = 5,
    this.height = 80,
  }) : super(key: key);

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.4, end: 0.7).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.itemCount,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Container(
            height: widget.height,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color:
                  Color.fromRGBO(9, 20, 40, _pulse.value),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              border: Border.all(
                  color: const Color(0xFF1A3A6B).withOpacity(0.5)),
            ),
          ),
        );
      },
    );
  }
}

/// Snackbar helper (dark premium styling)
class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, const Color(0xFF00C853), Icons.check_circle_rounded);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, const Color(0xFFCF6679), Icons.error_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, const Color(0xFFFFB300), Icons.warning_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, const Color(0xFF2979FF), Icons.info_rounded);
  }

  static void _show(
      BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
