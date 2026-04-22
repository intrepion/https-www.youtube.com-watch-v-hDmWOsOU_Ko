import 'package:flutter/material.dart';

import '../controls/prism_rotation_controls.dart';
import '../model/prism_models.dart';
import '../renderer/rectangular_prism.dart';
import 'prism_editor_constants.dart';

class PrismViewportPanel extends StatelessWidget {
  const PrismViewportPanel({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageOption,
    required this.prismFaceValues,
    required this.rotationControls,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final PrismImageOption imageOption;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismRotationControls rotationControls;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, panelConstraints) {
        final prismHeight =
            (panelConstraints.maxHeight * prismViewportHeightFactor).clamp(
              prismViewportMinHeight,
              prismViewportMaxHeight,
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            0,
            prismEditorPanelTopPadding,
            0,
            prismEditorPanelBottomPadding,
          ),
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
                        padding: const EdgeInsets.all(
                          prismViewportInnerPadding,
                        ),
                        child: RectangularPrism(
                          rx: rx,
                          ry: ry,
                          rz: rz,
                          zoom: zoom,
                          imageOption: imageOption,
                          prismFaceValues: prismFaceValues,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: prismViewportSectionSpacing),
                rotationControls,
              ],
            ),
          ),
        );
      },
    );
  }
}
