import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class RunTimeAumented extends StatefulWidget {
  _RunTimeAumentedState createState() => _RunTimeAumentedState();
}

class _RunTimeAumentedState extends State<RunTimeAumented> {
  late ArCoreController arCoreController;
  late ArCoreNode sphereNode;

  double metallic = 0.0;
  double roughness = 0.4;
  double reflectance = 0.5;
  Color color = Colors.yellow;
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    addSphere(arCoreController);
  }

  Future addSphere(ArCoreController coreController) async {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
    );
    final sphere = ArCoreSphere(materials: [material], radius: 0.1);
    final sphereNode =
        ArCoreNode(shape: sphere, position: vector.Vector3(0, 0, -1.5));
    coreController.addArCoreNode(sphereNode);
  }

  onColorChange(Color newColor) {
    if (newColor != this.color) {
      newColor = this.color;
      updateMaterials();
    }
  }

  onMetallicChange(double newMetallic) {
    if (newMetallic != this.metallic) {
      newMetallic = this.metallic;
      updateMaterials();
    }
  }

  onReflectanceChange(double newReflectance) {
    if (newReflectance != this.reflectance) {
      newReflectance = this.reflectance;
      updateMaterials();
    }
  }

  onRoughnessChange(double newRoughness) {
    if (newRoughness != this.roughness) {
      newRoughness = this.roughness;
      updateMaterials();
    }
  }

  void updateMaterials() {
    debugPrint("update Material");
    if (sphereNode == null) {
      return;
    } else {
      final material = ArCoreMaterial(
          metallic: metallic,
          color: color,
          reflectance: reflectance,
          roughness: roughness);
      sphereNode.shape.materials.value = [material];
    }
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
          SphereControl(
            intialColor: color,
            intialMetallic: metallic,
            intialReflectance: reflectance,
            intialRoughness: roughness,
            onColorChanged: onColorChange,
            onMetallicChanged: onMetallicChange,
            onReflectanceChanged: onReflectanceChange,
            onRoughnessChanged: onRoughnessChange,
          ),
          Expanded(
            child: ArCoreView(
              onArCoreViewCreated: whenArCoreViewCreated,
            ),
          )
        ],
      ),
    );
  }
}

class SphereControl extends StatefulWidget {
  final double intialReflectance;
  final double intialRoughness;

  final double intialMetallic;
  final Color intialColor;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onMetallicChanged;
  final ValueChanged<double> onReflectanceChanged;
  final ValueChanged<double> onRoughnessChanged;

  const SphereControl(
      {required this.intialColor,
      required this.intialMetallic,
      required this.intialReflectance,
      required this.intialRoughness,
      required this.onColorChanged,
      required this.onMetallicChanged,
      required this.onReflectanceChanged,
      required this.onRoughnessChanged});

  @override
  _SphereControlState createState() => _SphereControlState();
}

class _SphereControlState extends State<SphereControl> {
  late double reflectanceValue;
  late double metallicValue;
  late double roughnessValue;

  late Color color;

  void initState() {
    color = widget.intialColor;
    metallicValue = widget.intialMetallic;
    reflectanceValue = widget.intialReflectance;
    roughnessValue = widget.intialRoughness;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text("Random Color"),
                onPressed: () {
                  final newColor = Colors.accents[Random().nextInt(14)];
                  widget.onColorChanged(newColor);
                  setState(() {
                    color = newColor;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: color,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("metallic"),
              Checkbox(
                  value: metallicValue == 1.0,
                  onChanged: (value) {
                    metallicValue == value ? 1.0 : 0.0;
                    widget.onMetallicChanged(metallicValue);
                  })
            ],
          ),
          Row(children: <Widget>[
            Text("Roughness"),
            Expanded(
              child: Slider(
                value: roughnessValue,
                divisions: 10,
                onChangeEnd: (value) {
                  roughnessValue == value ? 1.0 : 0.0;
                  widget.onRoughnessChanged(roughnessValue);
                },
                onChanged: (double value) {
                  setState(() {
                    roughnessValue = value;
                  });
                },
              ),
            ),
          ]),
          Row(
            children: <Widget>[
              Text("Reflectance"),
              Expanded(
                child: Slider(
                  value: reflectanceValue,
                  divisions: 10,
                  onChangeEnd: (value) {
                    reflectanceValue = value;
                    widget.onReflectanceChanged(reflectanceValue);
                  },
                  onChanged: (double value) {
                    setState(() {
                      reflectanceValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
