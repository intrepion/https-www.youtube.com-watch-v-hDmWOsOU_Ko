import 'dart:math';

import 'package:flutter/material.dart';

import 'prism/prism_config.dart';
import 'prism/widgets/prism_image_preview.dart';
import 'prism/widgets/rectangular_prism.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rx = 0.0, _ry = 0.0, _rz = 0.0, _zoom = 1.0;
  bool _showFaceOverlays = false;
  late String _selectedImageAssetPath = prismImageAssetPaths.first;
  String _selectedFace = 'stem';
  late final Map<String, Map<String, Rect>> _prismFaceValuesByDimensions = {
    for (final entry in defaultPrismFaceValuesByDimensions.entries)
      entry.key: Map<String, Rect>.from(entry.value),
  };

  PrismImageOption get _selectedImageOption => prismImageOptions.firstWhere(
    (option) => option.assetPath == _selectedImageAssetPath,
  );

  Map<String, Rect> get _activePrismFaceValues =>
      _prismFaceValuesByDimensions[_selectedImageOption.dimensions.key]!;

  String _formatAngle(double radians) {
    final degrees = radians * 180 / pi;
    return '${radians.toStringAsFixed(2)} rad (${degrees.toStringAsFixed(1)} deg)';
  }

  String _formatZoom(double zoom) => '${zoom.toStringAsFixed(2)}x';
  String _formatCropValue(double value) => value.toStringAsFixed(4);

  Widget _sliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required String Function(double value) formatter,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${formatter(value)}'),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
        ],
      ),
    );
  }

  Rect _selectedCrop() => _activePrismFaceValues[_selectedFace]!;

  void _updateSelectedCrop({
    double? left,
    double? top,
    double? width,
    double? height,
  }) {
    final prismFaceValues = _activePrismFaceValues;
    final current = prismFaceValues[_selectedFace]!;
    final nextLeft = (left ?? current.left).clamp(0.0, 1.0);
    final nextTop = (top ?? current.top).clamp(0.0, 1.0);
    final maxWidth = max(minimumCropExtent, 1.0 - nextLeft);
    final maxHeight = max(minimumCropExtent, 1.0 - nextTop);
    final nextWidth = (width ?? current.width).clamp(
      minimumCropExtent,
      maxWidth,
    );
    final nextHeight = (height ?? current.height).clamp(
      minimumCropExtent,
      maxHeight,
    );

    setState(() {
      prismFaceValues[_selectedFace] = Rect.fromLTWH(
        nextLeft,
        nextTop,
        nextWidth,
        nextHeight,
      );
    });
  }

  List<Widget> _buildPrismControls() {
    return [
      _sliderControl(
        label: 'X',
        value: _rx,
        min: pi * -2,
        max: pi * 2,
        formatter: _formatAngle,
        onChanged: (value) => setState(() => _rx = value),
      ),
      _sliderControl(
        label: 'Y',
        value: _ry,
        min: pi * -2,
        max: pi * 2,
        formatter: _formatAngle,
        onChanged: (value) => setState(() => _ry = value),
      ),
      _sliderControl(
        label: 'Z',
        value: _rz,
        min: pi * -2,
        max: pi * 2,
        formatter: _formatAngle,
        onChanged: (value) => setState(() => _rz = value),
      ),
      _sliderControl(
        label: 'Zoom',
        value: _zoom,
        min: 0.4,
        max: 2.5,
        formatter: _formatZoom,
        onChanged: (value) => setState(() => _zoom = value),
      ),
    ];
  }

  List<Widget> _buildFaceControls() {
    final crop = _selectedCrop();
    return [
      _sliderControl(
        label: 'Left',
        value: crop.left,
        min: 0.0,
        max: 1.0,
        formatter: _formatCropValue,
        onChanged: (value) => _updateSelectedCrop(left: value),
      ),
      _sliderControl(
        label: 'Top',
        value: crop.top,
        min: 0.0,
        max: 1.0,
        formatter: _formatCropValue,
        onChanged: (value) => _updateSelectedCrop(top: value),
      ),
      _sliderControl(
        label: 'Width',
        value: crop.width,
        min: minimumCropExtent,
        max: 1.0,
        formatter: _formatCropValue,
        onChanged: (value) => _updateSelectedCrop(width: value),
      ),
      _sliderControl(
        label: 'Height',
        value: crop.height,
        min: minimumCropExtent,
        max: 1.0,
        formatter: _formatCropValue,
        onChanged: (value) => _updateSelectedCrop(height: value),
      ),
    ];
  }

  Widget _buildDropdownDecorator({
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: child,
      ),
    );
  }

  Widget _buildImagePanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        children: [
          _buildDropdownDecorator(
            label: 'Image',
            child: DropdownButton<String>(
              value: _selectedImageAssetPath,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: prismImageOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option.assetPath,
                  child: Text(option.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedImageAssetPath = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 240, maxHeight: 360),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: InteractiveViewer(
                constrained: false,
                minScale: 0.5,
                maxScale: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: PrismImagePreview(
                    imageAssetPath: _selectedImageAssetPath,
                    prismFaceValues: Map<String, Rect>.from(
                      _activePrismFaceValues,
                    ),
                    selectedFace: _selectedFace,
                    showFaceOverlays: _showFaceOverlays,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Face',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFace,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: prismFaceDropdownLabels.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedFace = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 170,
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Overlays'),
                    value: _showFaceOverlays,
                    onChanged: (value) =>
                        setState(() => _showFaceOverlays = value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._buildFaceControls(),
        ],
      ),
    );
  }

  Widget _buildPrismPanel(BoxConstraints constraints) {
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
                          rx: _rx,
                          ry: _ry,
                          rz: _rz,
                          zoom: _zoom,
                          imageAssetPath: _selectedImageAssetPath,
                          dimensions: _selectedImageOption.dimensions,
                          prismFaceValues: _activePrismFaceValues,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildPrismControls(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _rx += details.delta.dy * 0.01;
        _ry -= details.delta.dx * 0.01;
        setState(() {
          _rx %= pi * 2;
          _ry %= pi * 2;
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideLayout = constraints.maxWidth >= 960;

              if (isWideLayout) {
                return Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: _buildImagePanel(),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: _buildPrismPanel(constraints)),
                  ],
                );
              }

              return Column(
                children: [
                  Expanded(child: _buildImagePanel()),
                  const Divider(height: 1),
                  Expanded(child: _buildPrismPanel(constraints)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
