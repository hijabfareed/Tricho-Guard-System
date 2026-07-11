
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.isSender, required this.message});

  final bool isSender;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 0),
      child: Align(
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            color: isSender ? const Color(0xff407CE2) : const Color(0xfff1F1F1),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isSender ? Colors.white : const Color(0xff001E2F),
            ),
          ),
        ),
      ),
    );
  }
}
