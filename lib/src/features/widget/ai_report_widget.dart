import 'dart:convert';
import 'package:flutter/material.dart';

class AiReportWidget extends StatelessWidget {
  final bool isSender;
  final String label;
  final String confidence;
  final String? base64Image;

  const AiReportWidget({
    super.key,
    required this.isSender,
    required this.label,
    required this.confidence,
    this.base64Image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AI Hair Analysis",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("Result: $label"),
              Text("Confidence: $confidence%"),
              if (base64Image != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(base64Image!),
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
