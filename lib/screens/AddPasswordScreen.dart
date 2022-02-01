import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passme/controllers/PasswordController.dart';
import 'package:passme/models/Password.dart';
import 'package:passme/services/EncryptService.dart';

class AddPasswordScreen extends StatelessWidget {
  final PasswordController passwordController = Get.find();
  final EncryptService encryptService = Get.find();

  int? index;
  String? passPhrase;
  String defaultTitle = '';
  String defaultPassword = '';
  String defaultPassphrase = '';

  AddPasswordScreen({this.index, this.passPhrase}) {
    if (index != null && passPhrase != null) {
      var storedPassword = passwordController.passwords[index ?? 0];
      defaultTitle = storedPassword.title;
      defaultPassword =
          encryptService.decrypt(storedPassword.password, passPhrase ?? "");
      defaultPassphrase = passPhrase ?? "";
    }
  }
  var titleEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  var passphraseEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (index != null) {
      titleEditingController.text = defaultTitle;
      passwordEditingController.text = defaultPassword;
      passphraseEditingController.text = defaultPassphrase;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('Add new Password'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              children: [
                buildTitle(),
                const Divider(),
                buildPassword(),
                const Divider(),
                buildPassPhrase(),
                const Divider(),
                submitButton()
              ],
            ))));
  }

  Widget submitButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            if (index != null) {
              int idx = index ?? 0;
              passwordController.passwords[idx].title =
                  titleEditingController.text;
              passwordController.passwords[idx].password =
                  encryptService.encrypt(passwordEditingController.text,
                      passphraseEditingController.text);
            } else {
              passwordController.passwords.add(Password(
                  title: titleEditingController.text,
                  password: encryptService.encrypt(
                      passwordEditingController.text,
                      passphraseEditingController.text)));
            }
            Get.back();
          },
          child: const Text('Save'),
          style: TextButton.styleFrom(backgroundColor: Colors.green),
        )
      ],
    );
  }

  Widget buildTitle() {
    return Expanded(
      child: TextField(
        controller: titleEditingController,
        autofocus: true,
        decoration: const InputDecoration(
          label: Text('Title'),
          hintText: 'Your description',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        maxLength: 80,
      ),
    );
  }

  Widget buildPassword() {
    return Expanded(
      child: TextField(
        controller: passwordEditingController,
        autofocus: true,
        decoration: const InputDecoration(
          label: Text('Password'),
          hintText: 'Enter your password',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        maxLength: 200,
      ),
    );
  }

  Widget buildPassPhrase() {
    return Expanded(
      child: TextField(
        controller: passphraseEditingController,
        autofocus: true,
        decoration: const InputDecoration(
          label: Text('Passphrase'),
          hintText: 'Your passphrase [Recommended 32 characters]',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        maxLength: 32,
      ),
    );
  }
}
