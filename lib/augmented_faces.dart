import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class AugmentedFaces extends StatefulWidget {
  _AugmentedFacesState createState() => _AugmentedFacesState();
}

class _AugmentedFacesState extends State<AugmentedFaces> {
  late ArCoreFaceController arCoreFaceController;

  @override
  void dispose() {
    super.dispose();
    arCoreFaceController.dispose();
  }

  void whenArCoreViewCreated(ArCoreFaceController faceController) {
    arCoreFaceController = faceController;

    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load("ar_app\assets\fox_face_mesh_texture.png");

    arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: "fox_face.sfb");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AR GEometric Shapes"),
      ),
      body: ArCoreFaceView(
        onArCoreViewCreated: whenArCoreViewCreated,
        enableAugmentedFaces: true,
      ),
    );
  }
}
