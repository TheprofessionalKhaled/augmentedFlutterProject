import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArQuotes extends StatefulWidget {
  @override
  _ArQuotesState createState() => _ArQuotesState();
}

class _ArQuotesState extends State<ArQuotes> {
  late ArCoreController arCoreController;

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = controlOnPlaneTap;
  }

  controlOnPlaneTap(List<ArCoreHitTestResult> hits) {
    var hit = hits.first;
    addQuoteImage(hit);
  }

  Future addQuoteImage(ArCoreHitTestResult hitTestResult) async {
    final bytes =
        (await rootBundle.load("assets/elonmask.jpg")).buffer.asUint8List();
    final ImageQuote = ArCoreNode(
      image: ArCoreImage(bytes: bytes, width: 600, height: 600),
      position: hitTestResult.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation:
          hitTestResult.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),
    );
    arCoreController.addArCoreNodeWithAnchor(ImageQuote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Object"),
      ),
      body: ArCoreView(
        onArCoreViewCreated: whenArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
