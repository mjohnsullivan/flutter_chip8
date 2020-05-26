library flutter_chip8;

import 'package:flutter/widgets.dart';

import 'package:chip8/chip8.dart' as chip8;

class Chip8 extends StatefulWidget {
  Chip8({this.initialProgram, @required this.onCreated});
  final List<int> initialProgram;
  final Function(Chip8Controller controller) onCreated;

  @override
  createState() => _Chip8State();
}

class _Chip8State extends State<Chip8> {
  _Chip8State() : controller = Chip8Controller();
  final Chip8Controller controller;

  @override
  void initState() {
    super.initState();
    // Make sure that onCreated is called
    widget.onCreated(controller);
    // Add as listener to the emulator for redraw events
    controller.addListener(() => setState(() {}));
    // Start execution if an initial program was supplied
    if (widget.initialProgram != null) {
      controller.execute(widget.initialProgram);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      foregroundPainter: ScreenPainter(controller.vm.display),
    ));
  }
}

class ScreenPainter extends CustomPainter {
  ScreenPainter(this.pixels) : assert(pixels.length == 2048);
  final List<bool> pixels;

  @override
  void paint(Canvas canvas, Size size) {
    final pixelWidth = size.width / 64;
    final pixelHeight = size.height / 32;
    final paintOn = Paint()
      ..color = const Color(0xFF000000) // black
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill;
    for (int x = 0; x < 64; x++) {
      for (int y = 0; y < 32; y++) {
        if (pixels[x + (y * 64)]) {
          canvas.drawRect(
              Rect.fromLTWH(
                pixelWidth * x,
                pixelHeight * y,
                pixelWidth,
                pixelHeight,
              ),
              paintOn);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Chip8Controller with ChangeNotifier {
  Chip8Controller([List<int> program]) {
    if (program != null) {
      execute(program);
    }
  }
  chip8.Chip8 vm;

  /// The controller's listener for vm events
  void _vmListener() => notifyListeners();

  /// Resets the vm and starts execution of a new program
  void execute(List<int> program) {
    vm?.dispose(); // Clean up the old vm if necessary
    vm = chip8.Chip8()
      ..listen(_vmListener)
      ..loadProgram(program)
      ..runStreamed();
    // ..runAsync();
  }

  void pressKey(int key) {
    assert(key >= 0 && key <= 15);
    vm.pressKey(key);
  }

  void releaseKey(int key) {
    assert(key >= 0 && key <= 15);
    vm.releaseKey(key);
  }

  @override
  void dispose() {
    vm?.dispose();
    super.dispose();
  }
}
