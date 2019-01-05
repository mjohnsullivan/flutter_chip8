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
    controller.listen(() => setState(() {}));
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
    final paintOff = Paint()
      ..color = const Color(0x00000000) // transparent
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill;
    for (int x = 0; x < 64; x++) {
      for (int y = 0; y < 32; y++) {
        canvas.drawRect(
            Rect.fromLTWH(
              pixelWidth * x,
              pixelHeight * y,
              pixelWidth,
              pixelHeight,
            ),
            pixels[x + (y * 64)] ? paintOn : paintOff);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Chip8Controller {
  Chip8Controller([List<int> program]) {
    if (program != null) {
      execute(program);
    }
  }
  chip8.Chip8 vm;

  /// The controller's listener for vm events
  void _vmListener() => listeners.forEach((l) => l());

  /// Listeners for changes from the vm
  /// TODO: should this be a Set?
  final List<Function> listeners = <VoidCallback>[];

  /// Listen for events fired by the chip8 emulator
  void listen(VoidCallback listener) => listeners.add(listener);

  /// Remove a listener
  void remove(VoidCallback listener) => listeners.remove(listener);

  /// Resets the vm and starts execution of a new program
  void execute(List<int> program) {
    vm?.dispose(); // Clean up the old vm if necessary
    vm = chip8.Chip8()
      ..listen(_vmListener)
      ..loadProgram(program)
      ..runAsync();
  }

  void reset(List<int> program) => throw Exception('Not implemented');

  void dispose() => vm?.dispose();
}
