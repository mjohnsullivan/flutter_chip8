import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chip8/flutter_chip8.dart';

void main() {
  testWidgets('Chip8 widget runs a program', (WidgetTester tester) async {
    final program = <int>[
      0x60, 0x00, // put 0 in V0                       // 200
      0x61, 0x00, // put 1 in V1                       // 202
      0xA2, 0x0A, // set I to 0x20A                    // 204
      0xD0, 0x14, // draw a four line sprite at 0,0    // 206
      0x12, 0x0E, // jump to 0x208                     // 208
      0x55, 0xFF, // sprite data                       // 20A
      0x55, 0xAA, // sprite data                       // 20C
    ];
    final widget = Chip8(initialProgram: program, onCreated: (_) {});
    await tester.pumpWidget(widget);
  });
}
