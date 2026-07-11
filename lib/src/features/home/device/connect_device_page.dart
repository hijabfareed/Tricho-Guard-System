import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:al_hair_app/src/features/services/iot_service.dart';

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  State<ConnectDevicePage> createState() =>
      _ConnectDevicePageState();
}

class _ConnectDevicePageState
    extends State<ConnectDevicePage> {

  final IoTService _iotService = IoTService();
  List<BluetoothDevice> devices = [];
  bool isLoading = true;
  StreamSubscription? _iotSubscription;

  Map<String, dynamic>? liveData;

  @override
  void initState() {
    super.initState();
    _initBluetooth();

    _iotSubscription =
        _iotService.stream.listen((event) {

          if (!mounted) return;

          if (event["type"] == "status") {
            _showSnack(event["message"]);
            return;
          }

          if (event["type"] == "error") {
            _showSnack(event["message"], isError: true);
            return;
          }

          if (event["type"] == "data") {
            setState(() {
              liveData = event;
            });
          }
        });
  }

  void _showSnack(String? message,
      {bool isError = false}) {

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ""),
        backgroundColor:
        isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _initBluetooth() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    bool? isOn =
    await FlutterBluetoothSerial.instance
        .isEnabled;

    if (isOn == false) {
      await FlutterBluetoothSerial.instance
          .requestEnable();
    }

    devices =
    await FlutterBluetoothSerial.instance
        .getBondedDevices();

    setState(() {
      isLoading = false;
    });
  }

  /// ================= DASHBOARD =================
  Widget _buildDashboard() {

    if (liveData == null) {
      return const Center(
        child: Text(
          "Waiting for live data...",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    String prediction =
        liveData!["Prediction"] ?? "";

    double confidence = 0;

    final match =
    RegExp(r'\((.*?)%\)').firstMatch(prediction);

    if (match != null) {
      confidence =
          double.tryParse(match.group(1)!) ?? 0;
    }

    /// 🔥 Risk Level Logic
    String riskLevel;
    Color riskColor;

    if (confidence >= 75) {
      riskLevel = "HIGH";
      riskColor = Colors.red;
    } else if (confidence >= 45) {
      riskLevel = "MEDIUM";
      riskColor = Colors.orange;
    } else {
      riskLevel = "LOW";
      riskColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          /// Sensor Cards
          Row(
            children: [
              _sensorCard("Temp",
                  "${liveData!["Temperature"]}°C"),
              const SizedBox(width: 12),
              _sensorCard("Moisture",
                  "${liveData!["Moisture"]}%"),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _sensorCard("pH",
                  "${liveData!["pH"]}"),
            ],
          ),

          const SizedBox(height: 40),

          /// 🔥 RISK LEVEL SECTION
          Text(
            "Risk Level",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            riskLevel,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: riskColor,
            ),
          ),

          const SizedBox(height: 15),

          LinearProgressIndicator(
            value: confidence / 100,
            minHeight: 12,
            backgroundColor: Colors.grey.shade300,
            valueColor:
            AlwaysStoppedAnimation(riskColor),
          ),

          const SizedBox(height: 8),

          Text(
            "Confidence: ${confidence.toStringAsFixed(1)}%",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _sensorCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      AppBar(title: const Text("Live Scalp Dashboard")),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator())
          : Column(
        children: [

          /// DEVICE LIST
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder:
                  (context, index) {
                final device =
                devices[index];

                return ListTile(
                  title: Text(device.name ??
                      "Unknown"),
                  subtitle:
                  Text(device.address),
                  onTap: () async {

                    if (_iotService
                        .isConnected) {
                      _showSnack(
                          "Already Connected");
                      return;
                    }

                    _showSnack(
                        "🔄 Connecting...");
                    await _iotService
                        .connectToDevice(
                        device.address);
                  },
                );
              },
            ),
          ),

          const Divider(),

          Expanded(child: _buildDashboard()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _iotSubscription?.cancel();
    _iotService.dispose();
    super.dispose();
  }
}