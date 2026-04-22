import 'package:flutter/material.dart';

class AssetLoadPlaceholder extends StatelessWidget {
  const AssetLoadPlaceholder.loading({
    super.key,
    required this.width,
    required this.height,
  }) : message = 'Loading...',
       showSpinner = true;

  const AssetLoadPlaceholder.error({
    super.key,
    required this.width,
    required this.height,
    this.message = 'Image failed to load',
  }) : showSpinner = false;

  final double width;
  final double height;
  final String message;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showSpinner)
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else
                  Icon(
                    Icons.broken_image_outlined,
                    color: colorScheme.outline,
                    size: 30,
                  ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
