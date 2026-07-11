import 'package:image/image.dart' as img;

class HairCnnService {
  Future<void> loadModel() async {
    // TFLite is not supported on Flutter Web in this app's current setup.
  }

  Future<Map<String, dynamic>> predict(img.Image image) async {
    return {
      "isScalp": false,
      "message": "AI scalp detection is currently available on mobile builds only.",
    };
  }

  void dispose() {}
}
