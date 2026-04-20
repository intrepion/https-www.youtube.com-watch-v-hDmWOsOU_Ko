import 'dart:math';

import 'package:flutter/material.dart';

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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print('rx: $_rx, ry: $_ry, rz: $_rz');
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

class Cube extends StatelessWidget {
  const Cube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          // STARBOARD
          transform: Matrix4.identity()
            ..translate(100.0, 0.0, 0.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.orange,
            width: 200,
            height: 300,
            child: FlutterLogo(size: 200),
          ),
        ),
        Transform(
          // FRONT
          transform: Matrix4.identity()
            ..translate(0.0, 0.0, -100.0)
            ..rotateY(0),
          alignment: Alignment.center,
          child: Container(
            color: Colors.red,
            width: 200,
            height: 300,
            child: FlutterLogo(size: 200),
          ),
        ),
        Transform(
          // PORT
          transform: Matrix4.identity()
            ..translate(-100.0, 0.0, 0.0)
            ..rotateY(pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.purple,
            width: 200,
            height: 300,
            child: FlutterLogo(size: 200),
          ),
        ),
        Transform(
          // BACK
          transform: Matrix4.identity()
            ..translate(0.0, 0.0, 100.0)
            ..rotateY(pi),
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            width: 200,
            height: 300,
            child: FlutterLogo(size: 200),
          ),
        ),
        Transform(
          // BOTTOM
          transform: Matrix4.identity()
            ..translate(0.0, 200.0, 0.0)
            ..rotateX(pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.blue,
            width: 200,
            height: 200,
            child: FlutterLogo(size: 200),
          ),
        ),
        Transform(
          // TOP
          transform: Matrix4.identity()
            ..translate(0.0, -100.0, 0.0)
            ..rotateX(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.pink.withOpacity(0.8),
            width: 200,
            height: 200,
            child: FlutterLogo(size: 200),
          ),
        ),
      ],
    );
  }
}
