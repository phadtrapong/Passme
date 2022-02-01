import 'package:encrypt/encrypt.dart';

class EncryptService {
  String encrypt(String text, String keyText) {
    var finalKeyText = buildKey(keyText);
    print(finalKeyText);
    print(finalKeyText.length);
    final key = Key.fromUtf8(finalKeyText);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  String decrypt(String encrypted64, String keyText) {
    var finalKeyText = buildKey(keyText);
    print(finalKeyText);
    print(finalKeyText.length);
    final key = Key.fromUtf8(finalKeyText);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(encrypted64, iv: iv);

    return decrypted;
  }

  String buildKey(String keyText) {
    var finalKey = [];
    keyText.runes.forEach((element) {
      var character = new String.fromCharCode(element);
      finalKey.add(character);
    });
    while (finalKey.length < 32) {
      finalKey.add("a");
    }
    return finalKey.join();
  }
}
