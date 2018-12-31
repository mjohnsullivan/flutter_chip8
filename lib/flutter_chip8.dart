library flutter_chip8;

import 'package:flutter/widgets.dart';

import 'package:chip8/chip8.dart' as chip8;

class Chip8 extends StatefulWidget {
  Chip8({this.program});
  final List<int> program;

  @override
  _Chip8State createState() => _Chip8State();
}

class _Chip8State extends State<Chip8> {
  _Chip8State() : this.emulator = chip8.Chip8();
  final chip8.Chip8 emulator;

  @override
  void initState() {
    // Add as listener to the emulator for redraw events
    emulator.listen(() => setState(() {}));
    _runEmulator();
    super.initState();
  }

  @override
  void dispose() {
    emulator.dispose();
    super.dispose();
  }

  void _runEmulator() async {
    emulator.loadProgram(widget.program);
    emulator.runAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      foregroundPainter: ScreenPainter(emulator.display),
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
