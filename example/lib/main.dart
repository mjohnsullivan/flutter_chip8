import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_chip8/flutter_chip8.dart';

final programAssets = {
  'IBM Logo': 'assets/ibm_logo.ch8',
  'Framed MK1': 'assets/framed_mk1_samways_1980.ch8',
  'Framed MK2': 'assets/framed_mk2_samways_1980.ch8',
  'Clock': 'assets/clock_bill_fisher_1981.ch8',
  'Life': 'assets/life_samways_1980.ch8',
  'KeyPad Test': 'assets/keypad_test_hap_2006.ch8',
  'Space Invaders': 'assets/space_invaders_david_winter.ch8',
  'BC Test': 'assets/bc_test.ch8',
};

void main() => runApp(EmulatorApp());

class EmulatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chip8 Emulator',
      home: Scaffold(
        appBar: AppBar(title: Text('Chip8 Emulator')),
        body: EmulatorPage(),
      ),
    );
  }
}

class EmulatorPage extends StatefulWidget {
  @override
  createState() => _EmulatorPageState();
}

class _EmulatorPageState extends State<EmulatorPage> {
  String programName;
  Chip8Controller _controller;

  @override
  void initState() {
    super.initState();
    programName = programAssets.keys.first;
  }

  /// Called when the program name is updated
  void _updateProgramName(String selectedProgramName) async {
    setState(() => programName = selectedProgramName);
    final newProgram = await rootBundle.load(programAssets[programName]);
    _controller.execute(newProgram.buffer.asUint8List());
  }

  /// Called when a new Chip8 controller is created
  void _onControllerChanged(Chip8Controller controller) =>
      _controller = controller;

  /// Called when a key is pressed
  void _onKeyPressed(int key) => _controller.pressKey(key);

  /// Called when a key is pressed
  void _onKeyReleased(int key) => _controller.releaseKey(key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 9,
        child: Emulator(
          programName,
          _onControllerChanged,
          _onKeyPressed,
          _onKeyReleased,
        ),
      ),
      Flexible(
        flex: 1,
        child: ProgramSelector(
          programName,
          _updateProgramName,
        ),
      ),
    ]);
  }
}

/// Dropdown selector for the program name
class ProgramSelector extends StatelessWidget {
  ProgramSelector(this.programName, this.onProgramNameUpdate);
  final String programName;
  final Function(String) onProgramNameUpdate;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: programName,
      items: programAssets.keys
          .map((k) => DropdownMenuItem(value: k, child: Text(k)))
          .toList(),
      onChanged: (value) => onProgramNameUpdate(value),
    );
  }
}

/// Emulator display and controls
class Emulator extends StatelessWidget {
  Emulator(
    this.program,
    this.onControllerChanged,
    this.onKeyPressed,
    this.onKeyReleased,
  );
  final String program;
  final Function(Chip8Controller) onControllerChanged;
  final Function(int) onKeyPressed;
  final Function(int) onKeyReleased;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Material(
          elevation: 8,
          child: Container(
            width: 300,
            height: 150,
            child: FutureBuilder(
              future:
                  DefaultAssetBundle.of(context).load(programAssets[program]),
              builder: (context, AsyncSnapshot<ByteData> snapshot) =>
                  (snapshot.hasData)
                      ? Chip8(
                          initialProgram: snapshot.data.buffer.asUint8List(),
                          onCreated: (controller) =>
                              onControllerChanged(controller))
                      : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        KeyPad(onKeyPressed, onKeyReleased),
      ],
    );
  }
}

class KeyPad extends StatelessWidget {
  KeyPad(this.onPress, this.onRelease);
  final Function(int) onPress;
  final Function(int) onRelease;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 4; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 4; j++)
                Padding(
                    padding: EdgeInsets.all(10),
                    child: KeyPadKey(j + (i * 4), onPress, onRelease))
            ],
          )
      ],
    );
  }
}

class KeyPadKey extends StatelessWidget {
  KeyPadKey(this.keyNum, this.onPress, this.onRelease);
  final int keyNum;
  final Function(int) onPress;
  final Function(int) onRelease;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        child: Text('$keyNum'),
      ),
      onTapDown: (_) => onPress(keyNum),
      onTapUp: (_) => onRelease(keyNum),
    );
  }
}
