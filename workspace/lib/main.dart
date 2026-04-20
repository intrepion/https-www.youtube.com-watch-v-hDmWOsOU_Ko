import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

const _boxAssetPath = 'assets/scentsy-box-165x165x178-ewok.png';
const _tallFaceSize = Size(165, 178);
const _squareFaceSize = Size(165, 165);

// Normalized crop rectangles for each face.
// Values are percentages of box0001.png and can be tuned to pick exact areas.
const _cubeFaceSpecs = <CubeFaceSpec>[
  CubeFaceSpec(
    label: 'keel',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.0336, 0.0800, 0.2235, 0.3100),
  ),
  CubeFaceSpec(
    label: 'deck',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.2561, 0.0800, 0.2235, 0.3100),
  ),
  CubeFaceSpec(
    label: 'starboard',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.0336, 0.4100, 0.2235, 0.3300),
  ),
  CubeFaceSpec(
    label: 'stem',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.2561, 0.4100, 0.2235, 0.3300),
  ),
  CubeFaceSpec(
    label: 'port',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.4796, 0.4100, 0.2235, 0.3300),
  ),
  CubeFaceSpec(
    label: 'stern',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.7027, 0.4100, 0.2235, 0.3300),
  ),
];

final _cubeFaceSpecsByLabel = <String, CubeFaceSpec>{
  for (final spec in _cubeFaceSpecs) spec.label: spec,
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  String _formatAngle(double radians) {
    final degrees = radians * 180 / pi;
    return '${radians.toStringAsFixed(2)} rad (${degrees.toStringAsFixed(1)} deg)';
  }

  String _formatZoom(double zoom) => '${zoom.toStringAsFixed(2)}x';

  Widget _angleControl({
    required String axis,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$axis: ${_formatAngle(value)}'),
          Slider(value: value, min: pi * -2, max: pi * 2, onChanged: onChanged),
        ],
      ),
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
        _rx += details.delta.dx * 0.01;
        _ry += details.delta.dy * 0.01;
        setState(() {
          _rx %= pi * 2;
          _ry %= pi * 2;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RectangularPrism(rx: _rx, ry: _ry, rz: _rz, zoom: _zoom),
            ),
            const SizedBox(height: 32),
            _angleControl(
              axis: 'X',
              value: _rx,
              onChanged: (value) => setState(() => _rx = value),
            ),
            _angleControl(
              axis: 'Y',
              value: _ry,
              onChanged: (value) => setState(() => _ry = value),
            ),
            _angleControl(
              axis: 'Z',
              value: _rz,
              onChanged: (value) => setState(() => _rz = value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zoom: ${_formatZoom(_zoom)}'),
                  Slider(
                    value: _zoom,
                    min: 0.4,
                    max: 2.5,
                    onChanged: (value) => setState(() => _zoom = value),
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

class CubeFaceSpec {
  const CubeFaceSpec({
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
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;

  @override
  State<RectangularPrism> createState() => _RectangularPrismState();
}

class _RectangularPrismState extends State<RectangularPrism> {
  ui.Image? _boxImage;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener((
    imageInfo,
    _,
  ) {
    if (!mounted) return;
    setState(() => _boxImage = imageInfo.image);
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveBoxImage();
  }

  void _resolveBoxImage() {
    final stream = AssetImage(
      _boxAssetPath,
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
    final boxImage = _boxImage;
    final halfWidth = _squareFaceSize.width / 2;
    final halfDepth = _squareFaceSize.height / 2;
    final halfHeight = _tallFaceSize.height / 2;

    if (boxImage == null) {
      return const SizedBox(
        width: 165,
        height: 178,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prismRotation = Matrix4.identity()
      ..rotateX(widget.rx)
      ..rotateY(widget.ry)
      ..rotateZ(widget.rz);
    final prismTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.005)
      ..multiply(prismRotation);
    final orderedFaces = _orderedFaces(
      image: boxImage,
      rotation: prismRotation,
      halfWidth: halfWidth,
      halfDepth: halfDepth,
      halfHeight: halfHeight,
    );
    return Transform(
      transform: prismTransform,
      alignment: Alignment.center,
      child: Transform.scale(
        scale: widget.zoom,
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
    final spec = _cubeFaceSpecsByLabel[label];
    assert(spec != null, 'Missing face spec for "$label".');

    return CubeFace(image: image, spec: spec!);
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

class CubeFace extends StatelessWidget {
  const CubeFace({super.key, required this.image, required this.spec});

  final ui.Image image;
  final CubeFaceSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spec.size.width,
      height: spec.size.height,
      child: ClipRect(
        child: CustomPaint(
          size: spec.size,
          painter: _CubeFacePainter(image: image, crop: spec.crop),
        ),
      ),
    );
  }
}

class _CubeFacePainter extends CustomPainter {
  const _CubeFacePainter({required this.image, required this.crop});

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
  bool shouldRepaint(covariant _CubeFacePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.crop != crop;
  }
}
