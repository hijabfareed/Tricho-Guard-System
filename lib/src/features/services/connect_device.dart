import 'dart:io';
import 'dart:convert';

import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_bottomsheet.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_dialog.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/hair_cnn_service.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final HairCnnService hairCnn = HairCnnService();

  bool _modelLoaded = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      print("DEBUG: Starting to load models...");
      await hairCnn.loadModel();
      setState(() {
        _modelLoaded = true;
      });
      print("DEBUG: Models loaded successfully.");
    } catch (e) {
      print("DEBUG ERROR: Failed to load models: $e");
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      extendBodyBehindAppBar: true,
      appbarBackgroundColor: Colors.transparent,
      withAppBar: true,
      title: const Text(
        "Scalp AI Analysis",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            20.0.spaceH,

            /// IMAGE PICKER
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  color: AppColors.indigoColor.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.indigoColor),
                  borderRadius: BorderRadius.circular(15),
                  image: selectedImage != null
                      ? DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: selectedImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, size: 40),
                    10.0.spaceH,
                    const Text(
                      "Tap to Select Image",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
                    : null,
              ).center(),
            ),

            30.0.spaceH,

            /// ANALYZE BUTTON
            CommonButton(
              title: "Analyze",
              onTap: () async {
                if (selectedImage == null) {
                  CommonDialog.showCustomDialog(
                    context,
                    const Text("Please select an image first"),
                  );
                  return;
                }

                if (!_modelLoaded) {
                  CommonDialog.showCustomDialog(
                    context,
                    Text(_errorMessage != null
                        ? "Error: $_errorMessage"
                        : "Model is loading, please wait..."),
                  );
                  return;
                }

                _showLoading();

                final result =
                await _runPrediction(selectedImage!);

                getIt<NavigationService>().goBack();

                if (result["isScalp"] == false) {
                  _showNotScalpDialog(result["message"]);
                  return;
                }

                _showResultDialog(result);
              },
            ),
          ],
        ).paddingOnly(left: 25, right: 25),
      ),
    );
  }

  // ================= IMAGE PICK =================

  void _selectImage() {
    CommonBottomSheet.showBottomSheet(
      context,
      SizedBox(
        height: 150,
        child: Row(
          children: [
            Expanded(
              child: _pickerTile(
                icon: Icons.image,
                title: "Gallery",
                onTap: () async {
                  final picked =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => selectedImage = File(picked.path));
                  }
                },
              ),
            ),
            10.0.spaceW,
            Expanded(
              child: _pickerTile(
                icon: Icons.camera_alt_outlined,
                title: "Camera",
                onTap: () async {
                  final picked =
                  await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => selectedImage = File(picked.path));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lessBlack),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            6.0.spaceH,
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ================= AI LOGIC =================

  Future<Map<String, dynamic>> _runPrediction(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;

    final result = await hairCnn.predict(image);

    if (result["isScalp"] == false) {
      return result;
    }

    final base64Image = await _imageToBase64(file);

    await FirebaseFirestore.instance
        .collection('ai_predictions')
        .add({
      'userId': GetStorage().read('userid'),
      'aiLabel': result['label'],
      'aiConfidence': result['confidence'],
      'base64': base64Image,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return result;
  }

  Future<String> _imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resized = img.copyResize(image, width: 800);
    final jpg = img.encodeJpg(resized, quality: 70);
    return base64Encode(jpg);
  }

  // ================= UI HELPERS =================

  void _showLoading() {
    CommonDialog.showCustomDialog(
      context,
      SizedBox(
        height: 150,
        child: LoadingAnimationWidget.discreteCircle(
          color: const Color(0xff407CE2),
          size: 50,
        ).center(),
      ),
    );
  }

  void _showNotScalpDialog(String message) {
    CommonDialog.showCustomDialog(
      context,
      Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.red, size: 50),
            const SizedBox(height: 15),
            const Text(
              "Invalid Image",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            const SizedBox(height: 15),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  getIt<NavigationService>().goBack(),
              child: const Text("Try Again"),
            )
          ],
        ),
      ),
    );
  }

  void _showResultDialog(Map<String, dynamic> result) {
    final label = result['label'];
    final confidence = result['confidence'];

    Color riskColor = Colors.green;
    if (confidence > 80) {
      riskColor = Colors.red;
    } else if (confidence > 50) {
      riskColor = Colors.orange;
    }

    CommonDialog.showCustomDialog(
      context,
      Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () =>
                    getIt<NavigationService>().goBack(),
                child: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Scalp Analysis Result",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(label,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: riskColor)),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: confidence / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor:
              AlwaysStoppedAnimation(riskColor),
            ),
            const SizedBox(height: 8),
            Text(
              "Confidence: ${confidence.toStringAsFixed(1)}%",
            ),
          ],
        ),
      ),
    );
  }
}