import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class AugmentedImages extends StatefulWidget {
  _AugmentedImagesState createState() => _AugmentedImagesState();
}

class _AugmentedImagesState extends State<AugmentedImages> {
  late ArCoreController CoreController;
  Map<int, ArCoreAugmentedImage> augmentedImagesMap = Map();

  @override
  void dispose() {
    super.dispose();
    CoreController.dispose();
  }

  void whenArCoreViewCreated(ArCoreController arCoreController) {
    CoreController = arCoreController;
    arCoreController.onTrackingImage = controlOnTrackingImage;
    loadingSingleImage();
  }

  loadingSingleImage() async {
    final ByteData bytes =
        await rootBundle.load("assets\earth_augmented_image.jpg");
    CoreController.loadSingleAugmentedImage(bytes: bytes.buffer.asUint8List());
  }

  controlOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
      augmentedImagesMap[augmentedImage.index] = augmentedImage;
      addSphere(augmentedImage);
    }
  }

  addSphere(ArCoreAugmentedImage augmentedImage) async {
    final ByteData textureBytes = await rootBundle.load("assets/earth.jpg");
    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());
    final sphere =
        ArCoreSphere(materials: [material], radius: augmentedImage.extentX / 2);
    final node = ArCoreNode(
      shape: sphere,
    );
    CoreController.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AR GEometric Shapes"),
      ),
      body: ArCoreView(
        onArCoreViewCreated: whenArCoreViewCreated,
        type: ArCoreViewType.AUGMENTEDIMAGES,
      ),
    );
  }
}
