import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_chip8/flutter_chip8.dart';

final programAssets = <String, String>{
  'IBM Logo': 'assets/ibm_logo.ch8',
  'Framed MK1': 'assets/framed_mk1_samways_1980.ch8',
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

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
        flex: 9,
        child: Emulator(programName, _onControllerChanged),
      ),
      Flexible(
        flex: 1,
        child: ProgramSelector(programName, _updateProgramName),
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
          .map(
            (k) => DropdownMenuItem(value: k, child: Text(k)),
          )
          .toList(),
      onChanged: (value) => onProgramNameUpdate(value),
    );
  }
}

/// Emulator display and (coming soon) controls
class Emulator extends StatelessWidget {
  Emulator(this.program, this.onControllerChanged);
  final String program;
  final Function(Chip8Controller) onControllerChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8.0,
        child: Container(
          width: 300,
          height: 150,
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context).load(programAssets[program]),
            builder: (context, AsyncSnapshot<ByteData> snapshot) => (snapshot
                    .hasData)
                ? Chip8(
                    initialProgram: snapshot.data.buffer.asUint8List(),
                    onCreated: (controller) => onControllerChanged(controller))
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
