import 'package:flutter/material.dart';
import 'package:passme/controllers/PasswordController.dart';
import 'package:get/get.dart';
import 'package:passme/screens/AddPasswordScreen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final PasswordController controller = Get.put(PasswordController());
  var passPhraseEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PassMe'),
      ),
      body: Obx(() => controller.passwords.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: controller.passwords.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: ListTile(
                      title: Obx(() => Text(controller.passwords[index].title)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        if (passPhraseEditingController.text.isNotEmpty) {
                          passPhraseEditingController.text = "";
                        }
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                        Get.defaultDialog(
                            title: 'Confirm Passphrase',
                            content: buildPassphraseInput(),
                            textCancel: 'Close',
                            textConfirm: 'Submit',
                            onConfirm: () {
                              Get.back();
                              Get.to(AddPasswordScreen(
                                  index: index,
                                  passPhrase:
                                      passPhraseEditingController.text));
                            });
                      },
                    ),
                    onDismissed: (_) {
                      var removed = controller.passwords[index];
                      controller.passwords.removeAt(index);

                      Get.snackbar(
                          'Password Remove', '${removed.title} removed',
                          snackPosition: SnackPosition.BOTTOM,
                          mainButton: TextButton(
                              onPressed: () {
                                controller.passwords.insert(index, removed);
                                if (Get.isSnackbarOpen) {
                                  Get.back();
                                }
                              },
                              child: const Text(
                                'Undo',
                                style: TextStyle(color: Colors.black),
                              )));
                    });
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )
          : const Center(child: Text('empty'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddPasswordScreen());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget buildPassphraseInput() {
    return Expanded(
      child: TextField(
        controller: passPhraseEditingController,
        autofocus: true,
        decoration: const InputDecoration(
          label: Text('Passphrase'),
          hintText: 'Your Passphrase',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        maxLength: 200,
      ),
    );
  }
}
