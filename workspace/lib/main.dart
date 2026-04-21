import 'dart:math';

import 'package:flutter/material.dart';

import 'prism/prism_config.dart';
import 'prism/widgets/prism_controls.dart';
import 'prism/widgets/prism_editor_panels.dart';

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
      PrismRotationControls(
        rx: _rx,
        ry: _ry,
        rz: _rz,
        zoom: _zoom,
        onRxChanged: (value) => setState(() => _rx = value),
        onRyChanged: (value) => setState(() => _ry = value),
        onRzChanged: (value) => setState(() => _rz = value),
        onZoomChanged: (value) => setState(() => _zoom = value),
      ),
    ];
  }

  List<Widget> _buildFaceControls() {
    return [
      PrismFaceCropControls(
        crop: _selectedCrop(),
        onLeftChanged: (value) => _updateSelectedCrop(left: value),
        onTopChanged: (value) => _updateSelectedCrop(top: value),
        onWidthChanged: (value) => _updateSelectedCrop(width: value),
        onHeightChanged: (value) => _updateSelectedCrop(height: value),
      ),
    ];
  }

  Widget _buildImagePanel() {
    return PrismImagePanel(
      selectedImageAssetPath: _selectedImageAssetPath,
      imageOptions: prismImageOptions,
      prismFaceValues: _activePrismFaceValues,
      selectedFace: _selectedFace,
      showFaceOverlays: _showFaceOverlays,
      onImageChanged: (value) => setState(() => _selectedImageAssetPath = value),
      onFaceChanged: (value) => setState(() => _selectedFace = value),
      onShowFaceOverlaysChanged: (value) =>
          setState(() => _showFaceOverlays = value),
      faceControls: _buildFaceControls(),
    );
  }

  Widget _buildPrismPanel(BoxConstraints constraints) {
    return PrismViewportPanel(
      constraints: constraints,
      rx: _rx,
      ry: _ry,
      rz: _rz,
      zoom: _zoom,
      imageAssetPath: _selectedImageAssetPath,
      dimensions: _selectedImageOption.dimensions,
      prismFaceValues: _activePrismFaceValues,
      controls: _buildPrismControls(),
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
