import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_chip8/flutter_chip8.dart';

void main() => runApp(EmulatorApp());

class EmulatorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chip8 Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Chip8 Emulator')),
        body: Emulator(),
      ),
    );
  }
}

class Emulator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8.0,
        child: Container(
          width: 300,
          height: 150,
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context).load('assets/ibm_logo.ch8'),
            builder: (context, AsyncSnapshot<ByteData> snapshot) =>
                (snapshot.hasData)
                    ? Chip8(program: snapshot.data.buffer.asUint8List())
                    : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
