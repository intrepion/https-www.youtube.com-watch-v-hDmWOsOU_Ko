import 'package:flutter/material.dart';

class PrismEditorLayout extends StatelessWidget {
  const PrismEditorLayout({
    super.key,
    required this.imagePanel,
    required this.prismPanel,
  });

  final Widget imagePanel;
  final Widget prismPanel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideLayout = constraints.maxWidth >= 960;

        if (isWideLayout) {
          return Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: imagePanel,
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: prismPanel),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: imagePanel),
            const Divider(height: 1),
            Expanded(child: prismPanel),
          ],
        );
      },
    );
  }
}
