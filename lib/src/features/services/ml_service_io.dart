import 'dart:typed_data';

import 'package:al_hair_app/generated/assets.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(Assets.modelsRiskModel);
    await _loadLabels();
  }

  Future<void> _loadLabels() async {
    final raw = await rootBundle.loadString(Assets.modelsLabels);
    _labels = raw.split('\n').where((e) => e.trim().isNotEmpty).toList();
  }

  String runModel(double temp, double moisture, double ph) {
    final input = Float32List.fromList([temp, moisture, ph]).reshape([1, 3]);

    final outputShape = _interpreter.getOutputTensor(0).shape;
    final outputBuffer =
        Float32List(outputShape.reduce((a, b) => a * b)).reshape(outputShape);

    _interpreter.run(input, outputBuffer);

    final result = List<double>.from(outputBuffer[0]);
    double maxValue = result[0];

    for (int i = 1; i < result.length; i++) {
      if (result[i] > maxValue) {
        maxValue = result[i];
      }
    }

    final confidence = maxValue * 100;

    if (confidence >= 75) {
      return "HIGH (${confidence.toStringAsFixed(1)}%)";
    } else if (confidence >= 45) {
      return "MEDIUM (${confidence.toStringAsFixed(1)}%)";
    }

    return "LOW (${confidence.toStringAsFixed(1)}%)";
  }
}
