import 'package:al_hair_app/generated/assets.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class HairCnnService {
  late Interpreter _scalpInterpreter;
  late Interpreter _diseaseInterpreter;
  late List<String> _diseaseLabels;

  bool _isLoaded = false;

  Future<void> loadModel() async {
    _scalpInterpreter = await Interpreter.fromAsset(Assets.modelsScalpDetector);
    _diseaseInterpreter = await Interpreter.fromAsset("assets/models/dl_model.tflite");
    _diseaseLabels = await _loadLabels();
    _isLoaded = true;
  }

  Future<List<String>> _loadLabels() async {
    final raw = await rootBundle.loadString(Assets.modelsScalpDiseaseLabels);

    return raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> predict(img.Image image) async {
    if (!_isLoaded) {
      throw Exception("Models not loaded");
    }

    final scalpInput = _preprocessImage(image, isEfficientNet: false);
    final scalpOutput = List.generate(1, (_) => List.filled(1, 0.0));
    _scalpInterpreter.run(scalpInput, scalpOutput);

    final scalpProb = scalpOutput[0][0];
    if (scalpProb < 0.5) {
      return {
        "isScalp": false,
        "message": "Image is not scalp. Please capture scalp area clearly."
      };
    }

    final diseaseInput = _preprocessImage(image, isEfficientNet: true);
    final diseaseOutput = List.generate(
      1,
      (_) => List.filled(_diseaseLabels.length, 0.0),
    );

    _diseaseInterpreter.run(diseaseInput, diseaseOutput);

    final probs = List<double>.from(diseaseOutput[0]);
    double maxValue = probs[0];
    int maxIndex = 0;

    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > maxValue) {
        maxValue = probs[i];
        maxIndex = i;
      }
    }

    return {
      "isScalp": true,
      "label": _diseaseLabels[maxIndex],
      "confidence": maxValue * 100,
      "all_probs": probs,
    };
  }

  List<List<List<List<double>>>> _preprocessImage(
    img.Image image, {
    required bool isEfficientNet,
  }) {
    final resized = img.copyResize(image, width: 224, height: 224);

    return [
      List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);

          if (isEfficientNet) {
            return [
              (pixel.r / 127.5) - 1.0,
              (pixel.g / 127.5) - 1.0,
              (pixel.b / 127.5) - 1.0,
            ];
          }

          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        }),
      )
    ];
  }

  void dispose() {
    _scalpInterpreter.close();
    _diseaseInterpreter.close();
  }
}
