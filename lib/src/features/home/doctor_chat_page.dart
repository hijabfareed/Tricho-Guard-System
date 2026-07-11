import 'dart:convert';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DoctorChatPage extends StatefulWidget {

  final String chatId;
  final String patientName;

  const DoctorChatPage({
    super.key,
    required this.chatId,
    required this.patientName,
  });

  @override
  State<DoctorChatPage> createState() =>
      _DoctorChatPageState();
}

class _DoctorChatPageState
    extends State<DoctorChatPage> {

  final storage = GetStorage();
  final TextEditingController controller =
  TextEditingController();

  Future<void> sendText() async {

    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("Chat_Room")
        .add({
      "docId": widget.chatId,
      "senderId": storage.read('userid'),
      "type": "text",
      "message": controller.text.trim(),
      "createdAt": Timestamp.now(),
    });

    controller.clear();
  }

  Future<void> sendDocument() async {

    FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) return;

    final bytes = result.files.first.bytes;
    final fileName = result.files.first.name;

    if (bytes == null) return;

    final base64File = base64Encode(bytes);

    await FirebaseFirestore.instance
        .collection("Chat_Room")
        .add({
      "docId": widget.chatId,
      "senderId": storage.read('userid'),
      "type": "document",
      "fileName": fileName,
      "base64": base64File,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {

    final doctorId = storage.read('userid');

    return CommonScaffold(
      withAppBar: true,
      title: Text(widget.patientName),
      child: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Chat_Room")
                  .where('docId',
                  isEqualTo: widget.chatId)
                  .orderBy('createdAt',
                  descending: true)
                  .snapshots(),
              builder: (_, snap) {

                if (!snap.hasData) {
                  return const Center(
                      child:
                      CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount:
                  snap.data!.docs.length,
                  itemBuilder:
                      (_, i) {

                    final d =
                    snap.data!.docs[i];
                    final isMe =
                        d['senderId'] ==
                            doctorId;
                    final type =
                    d['type'];

                    if (type == "text") {
                      return Align(
                        alignment:
                        isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                          const EdgeInsets
                              .all(8),
                          padding:
                          const EdgeInsets
                              .all(12),
                          decoration:
                          BoxDecoration(
                            color: isMe
                                ? const Color(
                                0xff407CE2)
                                : Colors.grey
                                .shade200,
                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),
                          child: Text(
                            d['message'],
                            style:
                            TextStyle(
                              color: isMe
                                  ? Colors
                                  .white
                                  : Colors
                                  .black,
                            ),
                          ),
                        ),
                      );
                    }

                    if (type == "document") {
                      return Align(
                        alignment:
                        isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                          const EdgeInsets
                              .all(8),
                          padding:
                          const EdgeInsets
                              .all(12),
                          decoration:
                          BoxDecoration(
                            color: isMe
                                ? const Color(
                                0xff407CE2)
                                : Colors.grey
                                .shade200,
                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [

                              const Icon(
                                  Icons.insert_drive_file),

                              const SizedBox(
                                  width: 6),

                              Text(d[
                              'fileName']),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                );
              },
            ),
          ),

          Row(
            children: [

              IconButton(
                icon: const Icon(
                    Icons.attach_file),
                onPressed: sendDocument,
              ),

              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                  const InputDecoration(
                    hintText:
                    "Type message...",
                  ),
                ),
              ),

              IconButton(
                icon:
                const Icon(Icons.send),
                onPressed: sendText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
