import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'ml_service.dart';

class IoTService {
  BluetoothConnection? connection;
  StreamSubscription<Uint8List>? _subscription;
  final GetStorage _storage = GetStorage();

  final StreamController<Map<String, dynamic>> _controller =
  StreamController.broadcast();

  Stream<Map<String, dynamic>> get stream =>
      _controller.stream;

  final MLService _mlService = MLService();
  String _buffer = "";

  bool get isConnected =>
      connection?.isConnected ?? false;

  Future<void> connectToDevice(String address) async {
    try {
      _controller.add({
        "type": "status",
        "message": "🔄 Connecting..."
      });

      await _subscription?.cancel();
      await connection?.close();
      _storage.write('iotConnected', false);

      await _mlService.loadModel();

      connection =
      await BluetoothConnection.toAddress(address);

      _controller.add({
        "type": "status",
        "message": "✅ Connected Successfully"
      });
      _storage.write('iotConnected', true);

      _listenForData();
    } catch (e) {
      _storage.write('iotConnected', false);
      _controller.add({
        "type": "error",
        "message": "❌ Connection Failed"
      });

      print("Bluetooth Error: $e");
    }
  }

  void _listenForData() {
    _subscription =
        connection?.input?.listen((Uint8List data) {
          String received =
          utf8.decode(data, allowMalformed: true);

          _buffer += received;

          while (_buffer.contains('\n')) {
            int index = _buffer.indexOf('\n');
            String message =
            _buffer.substring(0, index).trim();
            _buffer =
                _buffer.substring(index + 1);

            _parseAndPredict(message);
          }
        });
  }

  void _parseAndPredict(String message) {
    final parts =
    message.split(RegExp(r'\s+'));

    if (parts.length < 3) return;

    double temp =
        double.tryParse(parts[0]) ?? 0;
    double moisture =
        double.tryParse(parts[1]) ?? 0;
    double ph =
        double.tryParse(parts[2]) ?? 0;

    String prediction =
    _mlService.runModel(temp, moisture, ph);

    _controller.add({
      "type": "data",
      "Temperature": temp,
      "Moisture": moisture,
      "pH": ph,
      "Prediction": prediction,
    });
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await connection?.close();
    _storage.write('iotConnected', false);

    _controller.add({
      "type": "status",
      "message": "🔌 Disconnected"
    });
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}