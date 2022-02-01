import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passme/screens/AuthScreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passme/services/EncryptService.dart';

void main() async {
  initServices();
  runApp(const GetMaterialApp(
    home: AuthScreen(),
  ));
}

void initServices() async {
  await GetStorage.init();
  Get.put(EncryptService());
}
