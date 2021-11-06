import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class Object3D extends StatefulWidget {
  _Object3DState createState() => _Object3DState();
}

class _Object3DState extends State<Object3D> {
  late ArCoreController arCoreController;
  late String objectSelected;

  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    arCoreController.onPlaneTap = _handleOnPlaneTap;
    arCoreController.onNodeTap = (name) => removeObject(name);
  }

  removeObject(String name) {
    showDialog(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            content: Row(
              children: [
                Text("Remove " + name),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    arCoreController.removeNode(nodeName: name);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    addObject(hit);
  }

  void addObject(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      final objectNode = ArCoreReferenceNode(
        name: objectSelected,
        object3DFileName: objectSelected,
        position: plane.pose.translation,
        rotation: plane.pose.rotation,
      );
      arCoreController.addArCoreNodeWithAnchor(objectNode);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext c) => AlertDialog(
                content: Text("select an image"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("3D Objects"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ArCoreView(
            onArCoreViewCreated: whenArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          (Align(
              alignment: Alignment.topLeft,
              child: ListObjectSelected((value) {
                objectSelected = value;
              })))
        ],
      ),
    );
  }
}

class ListObjectSelected extends StatefulWidget {
  final Function onTap;
  ListObjectSelected(this.onTap);
  _ListObjectSelectedState createState() => _ListObjectSelectedState();
}

class _ListObjectSelectedState extends State<ListObjectSelected> {
  List<String> gifs = [
    "assets/TocoToucan.gif",
    "assets/AndroidRobot.gif",
    "assets/ArcticFox.gif"
  ];

  List<String> objectFileName = ["toucan.sfb", "andy.sfb", "artic_fox.sfb"];

  late String selected;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap(objectFileName[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                color:
                    selected == gifs[index] ? Colors.red : Colors.transparent,
                padding: selected == gifs[index] ? EdgeInsets.all(8.0) : null,
                child: Image.asset(gifs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
