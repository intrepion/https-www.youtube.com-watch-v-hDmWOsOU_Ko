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
    label: 'bottom',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.03, 0.15, 0.22, 0.22),
  ),
  CubeFaceSpec(
    label: 'top',
    size: _squareFaceSize,
    crop: Rect.fromLTWH(0.27, 0.15, 0.22, 0.22),
  ),
  CubeFaceSpec(
    label: 'starboard',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.04, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'front',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.27, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'port',
    size: _tallFaceSize,
    crop: Rect.fromLTWH(0.48, 0.41, 0.22, 0.33),
  ),
  CubeFaceSpec(
    label: 'back',
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
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.005)
                ..rotateX(_rx)
                ..rotateY(_ry)
                ..rotateZ(_rz),
              alignment: Alignment.center,
              child: Center(child: Cube()),
            ),
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

class Cube extends StatefulWidget {
  const Cube({super.key});

  @override
  State<Cube> createState() => _CubeState();
}

class _CubeState extends State<Cube> {
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

    if (boxImage == null) {
      return const SizedBox(
        width: 200,
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        Transform(
          // BOTTOM
          transform: Matrix4.identity()
            ..translateByDouble(0.0, (_tallFaceSize.height / 2), 0.0, 1.0)
            ..rotateX(pi / 2),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'bottom'),
        ),
        Transform(
          // TOP
          transform: Matrix4.identity()
            ..translateByDouble(0.0, -(_tallFaceSize.height / 2), 0.0, 1.0)
            // ..rotateZ(pi)
            ..rotateX(-pi / 2),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'top'),
        ),
        Transform(
          // STARBOARD
          transform: Matrix4.identity()
            ..translateByDouble(-(_tallFaceSize.width / 2), 0.0, 0.0, 1.0)
            ..rotateY(pi / 2),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'starboard'),
        ),
        Transform(
          // FRONT
          transform: Matrix4.identity()
            ..translateByDouble(0.0, 0.0, -(_tallFaceSize.width / 2), 1.0)
            ..rotateY(0),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'front'),
        ),
        Transform(
          // PORT
          transform: Matrix4.identity()
            ..translateByDouble((_tallFaceSize.width / 2), 0.0, 0.0, 1.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'port'),
        ),
        Transform(
          // BACK
          transform: Matrix4.identity()
            ..translateByDouble(0.0, 0.0, (_tallFaceSize.width / 2), 1.0)
            ..rotateY(pi),
          alignment: Alignment.center,
          child: _buildFace(boxImage, 'back'),
        ),
      ],
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
    return Container(
      width: spec.size.width,
      height: spec.size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.18),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        size: spec.size,
        painter: _CubeFacePainter(image: image, crop: spec.crop),
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
