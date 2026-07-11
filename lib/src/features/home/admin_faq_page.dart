import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/features/controller/faq_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AdminFaqPage extends StatelessWidget {
  AdminFaqPage({super.key});

  final controller = FaqController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: Text(
        GetStorage().read('role') == 'admin' ? "Manage FAQs" : "FAQs",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      floatingActionButton: GetStorage().read('role') == 'admin' ? FloatingActionButton(
        onPressed: () => _openFaqSheet(context),
        child: const Icon(Icons.add),
      ) : 0.0.spaceH,
      child: StreamBuilder(
        stream: controller.fetchFaqs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No FAQs added yet"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final faq = docs[i].data();

              return Card(
                child: ListTile(
                  title: Text(
                    faq['question'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(faq['answer']),
                  trailing: GetStorage().read('role') == 'admin' ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openFaqSheet(
                          context,
                          id: docs[i].id,
                          question: faq['question'],
                          answer: faq['answer'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            controller.deleteFaq(docs[i].id),
                      ),
                    ],
                  ) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openFaqSheet(
      BuildContext context, {
        String? id,
        String? question,
        String? answer,
      }) {
    final qController = TextEditingController(text: question);
    final aController = TextEditingController(text: answer);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                id == null ? "Add FAQ" : "Edit FAQ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qController,
                decoration:
                const InputDecoration(labelText: "Question"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: aController,
                maxLines: 3,
                decoration:
                const InputDecoration(labelText: "Answer"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await controller.addFaq(
                      question: qController.text,
                      answer: aController.text,
                    );
                  } else {
                    await controller.updateFaq(
                      id: id,
                      question: qController.text,
                      answer: aController.text,
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }
}
