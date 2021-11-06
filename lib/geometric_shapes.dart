import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
class GeometricShapes extends StatefulWidget {
  _GeometricShapesState createState() => _GeometricShapesState();
}

class _GeometricShapesState extends State<GeometricShapes> {
  late ArCoreController arCoreController;
 void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    addSphere(arCoreController);
  }

  Future addSphere(ArCoreController coreController) async {
    final ByteData textureBytes = await rootBundle.load("assets/earth.jpg");
    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());
    final sphere = ArCoreSphere(materials: [material], radius: 0.1);
    final node =
        ArCoreNode(shape: sphere, position: vector.Vector3(0, 0, -1.5));
    coreController.addArCoreNode(node);
  }
 

  Future addCube(ArCoreController coreController) async {
    final ByteData textureBytes = await rootBundle.load("assets/earth.jpg");
    final material = ArCoreMaterial(color: Colors.green, metallic: 1.0);
    final cube = ArCoreCube(materials: [material], size:vector.Vector3(0.5, 0.5, 0.5));
    final node =
        ArCoreNode(shape: cube, position: vector.Vector3(0, 0, -1.5));
    coreController.addArCoreNode(node);
  }

  Future addCylinder(ArCoreController coreController) async {
    final ByteData textureBytes = await rootBundle.load("assets/earth.jpg");
    final material = ArCoreMaterial(
        color: Colors.red,
        reflectance: 1.0);
    final cylinder = ArCoreCylinder(materials: [material], radius: 0.1,height: 0.3);
    final node =
        ArCoreNode(shape: cylinder, position: vector.Vector3(0.0, -0.5, -2.0));
    coreController.addArCoreNode(node);
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
