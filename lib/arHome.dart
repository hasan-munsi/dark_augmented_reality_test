import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

class ARHome extends StatefulWidget {

  @override
  _ARHomeState createState() => _ARHomeState();
}

class _ARHomeState extends State<ARHome> {
  ArCoreController _controller;
  ByteData imageData;

  @override
  void initState() {
    super.initState();
    rootBundle.load('images/111.png')
        .then((data) => setState(() => this.imageData = data));
  }
  _arCoreCreated(ArCoreController controller){
    _controller = controller;
    _addCube(_controller);
  }

  _addCube(ArCoreController controller){
    final material = ArCoreMaterial(
      color: Color(0xFF00FF00),
      metallic: 1.0,
    );
    final image = ArCoreImage(
      width: 500,
      height: 500,
      bytes: imageData.buffer.asUint8List(),
    );
    final cube = ArCoreSphere(
      materials: [material],
      radius: 0.5,
    );
    final node = ArCoreNode(
      image: image,
      position: Vector3(0, 0, -3),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _arCoreCreated,
      ),
    );
  }
}
