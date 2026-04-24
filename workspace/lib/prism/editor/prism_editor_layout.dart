import 'package:flutter/material.dart';

class PrismEditorLayout extends StatelessWidget {
  const PrismEditorLayout({
    super.key,
    required this.imagePanel,
    required this.prismPanel,
  });

  final Widget? imagePanel;
  final Widget prismPanel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (imagePanel == null) {
          return prismPanel;
        }

        final isWideLayout = constraints.maxWidth >= 960;

        if (isWideLayout) {
          return Row(
            children: [
              Expanded(child: prismPanel),
              const VerticalDivider(width: 1),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: imagePanel!,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: prismPanel),
            const Divider(height: 1),
            Expanded(child: imagePanel!),
          ],
        );
      },
    );
  }
}
