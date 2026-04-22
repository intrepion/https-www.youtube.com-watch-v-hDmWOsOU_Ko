import 'package:flutter/material.dart';

import '../controls/prism_rotation_controls.dart';
import '../prism_config.dart';
import '../renderer/rectangular_prism.dart';

class PrismViewportPanel extends StatelessWidget {
  const PrismViewportPanel({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageAssetPath,
    required this.dimensions,
    required this.prismFaceValues,
    required this.rotationControls,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final String imageAssetPath;
  final PrismDimensions dimensions;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismRotationControls rotationControls;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, panelConstraints) {
        final prismHeight =
            (panelConstraints.maxHeight * 0.52).clamp(180.0, 420.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: panelConstraints.maxHeight),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: prismHeight,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: RectangularPrism(
                          rx: rx,
                          ry: ry,
                          rz: rz,
                          zoom: zoom,
                          imageAssetPath: imageAssetPath,
                          dimensions: dimensions,
                          prismFaceValues: prismFaceValues,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                rotationControls,
              ],
            ),
          ),
        );
      },
    );
  }
}
