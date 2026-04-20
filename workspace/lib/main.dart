import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

const _boxAssetPath = 'assets/box0001.png';
const _tallFaceSize = Size(165, 178);
const _squareFaceSize = Size(165, 165);

// Normalized crop rectangles for each face.
// Values are percentages of box0001.png and can be tuned to pick exact areas.
const _cubeFaceSpecs = <CubeFaceSpec>[
  CubeFaceSpec(
    label: 'keel',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.03, 0.15, 0.22, 0.22),
  ),
  CubeFaceSpec(
    label: 'deck',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.27, 0.15, 0.22, 0.22),
  ),
  CubeFaceSpec(
    label: 'starboard',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.04, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'stem',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.27, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'port',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.48, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'stern',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.71, 0.41, 0.22, 0.33),
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
  double _rx = 0.0, _ry = 0.0, _rz = 0.0;

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
            Center(child: RectangularPrism(rx: _rx, ry: _ry, rz: _rz)),
            const SizedBox(height: 32),
            Slider(
              value: _rx,
              min: pi * -2,
              max: pi * 2,
              onChanged: (value) => setState(() => _rx = value),
            ),
            Slider(
              value: _ry,
              min: pi * -2,
              max: pi * 2,
              onChanged: (value) => setState(() => _ry = value),
            ),
            Slider(
              value: _rz,
              min: pi * -2,
              max: pi * 2,
              onChanged: (value) => setState(() => _rz = value),
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
  });

  final double rx;
  final double ry;
  final double rz;

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
        width: 200,
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prismTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.005)
      ..rotateX(widget.rx)
      ..rotateY(widget.ry)
      ..rotateZ(widget.rz);
    return Transform(
      transform: prismTransform,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
              ..rotateY(pi),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'stern'),
          ),
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
              ..rotateX(-pi / 2),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'keel'),
          ),
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
              ..rotateY(-pi / 2),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'starboard'),
          ),
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
              ..rotateY(pi / 2),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'port'),
          ),
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
              ..rotateX(pi / 2),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'deck'),
          ),
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
            alignment: Alignment.center,
            child: _buildFace(boxImage, 'stem'),
          ),
        ],
      ),
    );
  }

  Widget _buildFace(ui.Image image, String label) {
    final spec = _cubeFaceSpecsByLabel[label];
    assert(spec != null, 'Missing face spec for "$label".');

    return CubeFace(image: image, spec: spec!);
  }
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
