import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passme/models/Password.dart';

class PasswordController extends GetxController {
  var passwords = List<Password>.empty().obs;

  @override
  void onInit() {
    List? storedPasswords = GetStorage().read<List>('passme');

    if (storedPasswords?.isNotEmpty ?? false) {
      passwords =
          storedPasswords?.map((e) => Password.fromJson(e)).toList().obs ??
              List<Password>.empty().obs;
    }
    ever(passwords, (_) {
      GetStorage().write('passme', passwords.toList());
    });
    super.onInit();
  }
}
