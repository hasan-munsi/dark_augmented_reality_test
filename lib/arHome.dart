
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARHome extends StatefulWidget {

  @override
  _ARHomeState createState() => _ARHomeState();
}

class _ARHomeState extends State<ARHome> {
  ArCoreController _controller;
  ByteData earthImageData;
  ByteData moonImageData;

  @override
  void initState() {
    super.initState();
    rootBundle.load('images/earth.jpg')
        .then((data) => setState(() => this.earthImageData = data));
    rootBundle.load('images/moon.jpg')
        .then((data) => setState(() => this.moonImageData = data));
  }
  _arCoreCreated(ArCoreController controller){
    _controller = controller;
    _controller.onPlaneTap = _addCube;

    // _controller.onPlaneDetected = _addCube;
  }

  _addCube(List<ArCoreHitTestResult> hits){
    final plane = hits.first;
    final moonMaterial = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: moonImageData.buffer.asUint8List(),
    );
    final moonShape = ArCoreSphere(
      radius: 0.1,
      materials: [moonMaterial],
    );
    final moonNode = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0,1,-1),
    );
    final earthMaterial = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: earthImageData.buffer.asUint8List(),
    );
    final earthSphere = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.3,
    );
    final node = ArCoreNode(
      shape: earthSphere,
      children: [moonNode],
      position: plane.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation: plane.pose.rotation,
    );
    _controller.addArCoreNodeWithAnchor(node);
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
        enableTapRecognizer: true,
      ),
    );
  }
}
