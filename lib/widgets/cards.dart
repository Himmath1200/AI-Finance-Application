import 'package:flutter/material.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Common card widget for displaying financial information
class FinanceCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? valueColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const FinanceCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.backgroundColor,
    this.titleColor,
    this.valueColor,
    this.icon,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: backgroundColor ?? Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        child: Padding(
          padding:
              padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: titleColor,
                        ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: titleColor ?? Colors.grey,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppConstants.paddingXSmall),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Gradient card widget
class GradientCard extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> colors;
  final IconData? icon;
  final VoidCallback? onTap;

  const GradientCard({
    Key? key,
    required this.title,
    required this.value,
    required this.colors,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal info card
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? backgroundColor;
  final Color? iconColor;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor ?? Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
              ),
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Icon(
                icon,
                color: iconColor ?? Colors.blue,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
