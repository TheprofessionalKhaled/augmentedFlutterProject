import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AvengersCharacters extends StatefulWidget {
  _AvengersCharactersState createState() => _AvengersCharactersState();
}

class _AvengersCharactersState extends State<AvengersCharacters> {
  late ArCoreController arCoreController;

  @override
  void dispose() {
    super.dispose();
  }

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    controller.onPlaneTap = controlOnPlanTap;
  }

  void controlOnPlanTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    addCharacter(hit);
  }

  Future addCharacter(ArCoreHitTestResult hit) async {
    final bytes =
        (await rootBundle.load("assets/ironman.png")).buffer.asUint8List();
    final characterPros =ArCoreNode(image: ArCoreImage(
      bytes: bytes,width: 500,height: 500,),
      position: hit.pose.translation + vector.Vector3(0.0,0.0,0.0),
      rotation: hit.pose.rotation + vector.Vector4(0,0 ,0,0),
    );
      arCoreController.addArCoreNode(characterPros);
      
        }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AR GEometric Shapes"),
      ),
      body: ArCoreView(onArCoreViewCreated: whenArCoreViewCreated),
    );
  }
}
