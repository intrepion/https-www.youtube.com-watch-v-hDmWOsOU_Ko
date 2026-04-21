import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

const _prismImageAssetPaths = <String>[
  'assets/scentsy-box-165x165x178-ewok.png',
  'assets/scentsy-box-165x165x178-elsa.png',
  'assets/scentsy-box-165x165x270-cinderella.png',
  'assets/scentsy-box-165x165x270-santa-stitch.png',
];
const _minimumCropExtent = 0.05;

// Normalized crop rectangles keyed by flat-pack dimensions.
const _defaultPrismFaceValuesByDimensions = <String, Map<String, Rect>>{
  '165x165x178': {
    'keel': Rect.fromLTWH(0.0336, 0.0800, 0.2235, 0.3100),
    'deck': Rect.fromLTWH(0.2561, 0.0800, 0.2235, 0.3100),
    'starboard': Rect.fromLTWH(0.0336, 0.4100, 0.2235, 0.3300),
    'stem': Rect.fromLTWH(0.2561, 0.4100, 0.2235, 0.3300),
    'port': Rect.fromLTWH(0.4796, 0.4100, 0.2235, 0.3300),
    'stern': Rect.fromLTWH(0.7027, 0.4100, 0.2235, 0.3300),
  },
  '165x165x270': {
    'keel': Rect.fromLTWH(0.0336, 0.0641, 0.2235, 0.2730),
    'deck': Rect.fromLTWH(0.2561, 0.0641, 0.2235, 0.2730),
    'starboard': Rect.fromLTWH(0.0200, 0.3386, 0.2235, 0.4642),
    'stem': Rect.fromLTWH(0.2504, 0.3386, 0.2235, 0.4642),
    'port': Rect.fromLTWH(0.4947, 0.3386, 0.2235, 0.4642),
    'stern': Rect.fromLTWH(0.7204, 0.3386, 0.2235, 0.4642),
  },
};
const _prismFaceDropdownLabels = <String, String>{
  'starboard': 'Starboard',
  'stem': 'Stem',
  'port': 'Port',
  'stern': 'Stern',
  'deck': 'Deck',
  'keel': 'Keel',
};
final _prismImageOptions = _prismImageAssetPaths
    .map(PrismImageOption.fromAssetPath)
    .toList(growable: false);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rx = 0.0, _ry = 0.0, _rz = 0.0, _zoom = 1.0;
  late String _selectedImageAssetPath = _prismImageAssetPaths.first;
  String _selectedFace = 'stem';
  late final Map<String, Map<String, Rect>> _prismFaceValuesByDimensions = {
    for (final entry in _defaultPrismFaceValuesByDimensions.entries)
      entry.key: Map<String, Rect>.from(entry.value),
  };

  PrismImageOption get _selectedImageOption => _prismImageOptions.firstWhere(
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

  Rect _selectedCrop() {
    return _activePrismFaceValues[_selectedFace]!;
  }

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
    final maxWidth = max(_minimumCropExtent, 1.0 - nextLeft);
    final maxHeight = max(_minimumCropExtent, 1.0 - nextTop);
    final nextWidth = (width ?? current.width).clamp(
      _minimumCropExtent,
      maxWidth,
    );
    final nextHeight = (height ?? current.height).clamp(
      _minimumCropExtent,
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
        min: _minimumCropExtent,
        max: 1.0,
        formatter: _formatCropValue,
        onChanged: (value) => _updateSelectedCrop(width: value),
      ),
      _sliderControl(
        label: 'Height',
        value: crop.height,
        min: _minimumCropExtent,
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
              items: _prismImageOptions.map((option) {
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
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  _selectedImageAssetPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdownDecorator(
            label: 'Face',
            child: DropdownButton<String>(
              value: _selectedFace,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: _prismFaceDropdownLabels.entries.map((entry) {
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
          const SizedBox(height: 12),
          ..._buildFaceControls(),
        ],
      ),
    );
  }

  Widget _buildPrismPanel(BoxConstraints constraints) {
    final prismHeight = max(280.0, constraints.maxHeight * 0.56);

    return Column(
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
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: Column(children: _buildPrismControls()),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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

class PrismDimensions {
  const PrismDimensions({
    required this.width,
    required this.depth,
    required this.height,
  });

  final int width;
  final int depth;
  final int height;

  String get key => '${width}x${depth}x$height';
  Size get topFaceSize => Size(width.toDouble(), depth.toDouble());
  Size get sideFaceSize => Size(width.toDouble(), height.toDouble());
}

class PrismImageOption {
  PrismImageOption({
    required this.assetPath,
    required this.dimensions,
    required this.name,
  });

  factory PrismImageOption.fromAssetPath(String assetPath) {
    final match = RegExp(
      r'^assets/scentsy-box-(\d+)x(\d+)x(\d+)-(.+)\.png$',
    ).firstMatch(assetPath);
    if (match == null) {
      throw ArgumentError.value(
        assetPath,
        'assetPath',
        'Unexpected asset name',
      );
    }

    final width = int.parse(match.group(1)!);
    final depth = int.parse(match.group(2)!);
    final height = int.parse(match.group(3)!);
    final rawName = match.group(4)!;

    return PrismImageOption(
      assetPath: assetPath,
      dimensions: PrismDimensions(width: width, depth: depth, height: height),
      name: rawName,
    );
  }

  final String assetPath;
  final PrismDimensions dimensions;
  final String name;

  String get label => '${_titleCaseWords(name)} (${dimensions.key})';
}

String _titleCaseWords(String value) {
  return value
      .split('-')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class PrismFaceSpec {
  const PrismFaceSpec({
    required this.label,
    required this.size,
    required this.crop,
  });

  final String label;
  final Size size;
  final Rect crop;
}

class RectangularPrism extends StatefulWidget {
  const RectangularPrism({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageAssetPath,
    required this.dimensions,
    required this.prismFaceValues,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final String imageAssetPath;
  final PrismDimensions dimensions;
  final Map<String, Rect> prismFaceValues;

  @override
  State<RectangularPrism> createState() => _RectangularPrismState();
}

class _RectangularPrismState extends State<RectangularPrism> {
  ui.Image? _prismImage;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener((
    imageInfo,
    _,
  ) {
    if (!mounted) return;
    setState(() => _prismImage = imageInfo.image);
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvePrismImage();
  }

  @override
  void didUpdateWidget(covariant RectangularPrism oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageAssetPath != widget.imageAssetPath) {
      _resolvePrismImage();
    }
  }

  void _resolvePrismImage() {
    final stream = AssetImage(
      widget.imageAssetPath,
    ).resolve(createLocalImageConfiguration(context));

    if (_imageStream?.key == stream.key) return;

    _imageStream?.removeListener(_imageListener);
    _imageStream = stream..addListener(_imageListener);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prismImage = _prismImage;
    final halfWidth = widget.dimensions.topFaceSize.width / 2;
    final halfDepth = widget.dimensions.topFaceSize.height / 2;
    final halfHeight = widget.dimensions.sideFaceSize.height / 2;

    if (prismImage == null) {
      return SizedBox(
        width: widget.dimensions.width.toDouble(),
        height: widget.dimensions.height.toDouble(),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prismRotation = Matrix4.identity()
      ..rotateX(widget.rx)
      ..rotateY(widget.ry)
      ..rotateZ(widget.rz);
    final prismTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.005)
      ..multiply(prismRotation)
      ..scaleByDouble(widget.zoom, widget.zoom, widget.zoom, 1.0);
    final orderedFaces = _orderedFaces(
      image: prismImage,
      rotation: prismRotation,
      halfWidth: halfWidth,
      halfDepth: halfDepth,
      halfHeight: halfHeight,
    );
    return Transform(
      transform: prismTransform,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: orderedFaces.map((face) {
          return Transform(
            transform: face.transform,
            alignment: Alignment.center,
            child: face.child,
          );
        }).toList(),
      ),
    );
  }

  List<_OrderedPrismFace> _orderedFaces({
    required ui.Image image,
    required Matrix4 rotation,
    required double halfWidth,
    required double halfDepth,
    required double halfHeight,
  }) {
    final faces = <_OrderedPrismFace>[];

    for (final face in [
      _PrismFacePlacement(
        label: 'stern',
        center: vm.Vector3(0.0, 0.0, halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
          ..rotateY(pi),
      ),
      _PrismFacePlacement(
        label: 'keel',
        center: vm.Vector3(0.0, halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
          ..rotateX(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'starboard',
        center: vm.Vector3(-halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'port',
        center: vm.Vector3(halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'deck',
        center: vm.Vector3(0.0, -halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
          ..rotateX(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'stem',
        center: vm.Vector3(0.0, 0.0, -halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
      ),
    ]) {
      final rotatedCenter = rotation.transform3(vm.Vector3.copy(face.center));
      faces.add(
        _OrderedPrismFace(
          depth: rotatedCenter.z,
          transform: face.transform,
          child: _buildFace(image, face.label),
        ),
      );
    }

    // Paint far faces first and near faces last so the exterior stays on top.
    faces.sort((a, b) => b.depth.compareTo(a.depth));
    return faces;
  }

  Widget _buildFace(ui.Image image, String label) {
    final crop = widget.prismFaceValues[label];
    assert(crop != null, 'Missing face values for "$label".');
    final size = switch (label) {
      'deck' || 'keel' => widget.dimensions.topFaceSize,
      _ => widget.dimensions.sideFaceSize,
    };

    return PrismFace(
      image: image,
      spec: PrismFaceSpec(label: label, size: size, crop: crop!),
    );
  }
}

class _PrismFacePlacement {
  const _PrismFacePlacement({
    required this.label,
    required this.center,
    required this.transform,
  });

  final String label;
  final vm.Vector3 center;
  final Matrix4 transform;
}

class _OrderedPrismFace {
  const _OrderedPrismFace({
    required this.depth,
    required this.transform,
    required this.child,
  });

  final double depth;
  final Matrix4 transform;
  final Widget child;
}

class PrismFace extends StatelessWidget {
  const PrismFace({super.key, required this.image, required this.spec});

  final ui.Image image;
  final PrismFaceSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spec.size.width,
      height: spec.size.height,
      child: ClipRect(
        child: CustomPaint(
          size: spec.size,
          painter: _PrismFacePainter(image: image, crop: spec.crop),
        ),
      ),
    );
  }
}

class _PrismFacePainter extends CustomPainter {
  const _PrismFacePainter({required this.image, required this.crop});

  final ui.Image image;
  final Rect crop;

  @override
  void paint(Canvas canvas, Size size) {
    final sourceRect = Rect.fromLTWH(
      crop.left * image.width,
      crop.top * image.height,
      crop.width * image.width,
      crop.height * image.height,
    );

    canvas.drawImageRect(
      image,
      sourceRect,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _PrismFacePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.crop != crop;
  }
}
