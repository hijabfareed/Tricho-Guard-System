class MLService {
  Future<void> loadModel() async {
    // TFLite is not supported on Flutter Web in this app's current setup.
  }

  String runModel(double temp, double moisture, double ph) {
    final score = ((temp * 0.34) + (moisture * 0.33) + (ph * 0.33)).clamp(0, 100);

    if (score >= 75) {
      return "HIGH (${score.toStringAsFixed(1)}%)";
    } else if (score >= 45) {
      return "MEDIUM (${score.toStringAsFixed(1)}%)";
    }

    return "LOW (${score.toStringAsFixed(1)}%)";
  }
}
