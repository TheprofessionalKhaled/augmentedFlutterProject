import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class AnchoredObject extends StatefulWidget {
  _AnchoredObjectState createState() => _AnchoredObjectState();
}

class _AnchoredObjectState extends State<AnchoredObject> {
  late ArCoreController arCoreController;

  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void onTapHandler(String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text("on Node Tap on $name"),
            ));
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addSphere(hit);
  }

  Future _addSphere(ArCoreHitTestResult hit) async {
    final moonMaterial = ArCoreMaterial(
      color: Colors.grey,
    );
    final moonShape = ArCoreSphere(materials: [moonMaterial], radius: 0.1);
    final moonNode = ArCoreNode(
        shape: moonShape,
        position: vector.Vector3(0, 0, -1.5),
        rotation: vector.Vector4(0, 0, 0, 0));
    final ByteData textureByte = await rootBundle.load("assets/earth.jpg");

    final earthMaterial = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
    );
    final earthShape = ArCoreSphere(materials: [earthMaterial], radius: 0.1);
    final earth = ArCoreNode(
        shape: earthShape,
        children: [moonNode],
        position: hit.pose.translation + vector.Vector3(0, 1.0, 0),
        rotation: hit.pose.rotation);

    arCoreController.addArCoreNodeWithAnchor(earth);
  }

 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AR GEometric Shapes"),
      ),
      body: Column(
        children: <Widget>[
          (Expanded(
            child: ArCoreView(
              onArCoreViewCreated: whenArCoreViewCreated,
              enableTapRecognizer: true,
            ),
          )),
        ],
      ),
    );
  }
}
