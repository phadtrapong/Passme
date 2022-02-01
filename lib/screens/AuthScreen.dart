import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:passme/screens/HomeScreen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthStateFul();
  }
}

class AuthStateFul extends StatefulWidget {
  const AuthStateFul({Key? key}) : super(key: key);

  @override
  State<AuthStateFul> createState() => _AuthStateFul();
}

class _AuthStateFul extends State<AuthStateFul> {
  String authSuccess = 'ok';
  String authFail = "nope";

  var localAuth = LocalAuthentication();

  Future<String> _isValid() async {
    bool isValid = false;
    try {
      isValid = await localAuth.authenticate(
          localizedReason: 'Please verify yourself',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {}

    return isValid ? authSuccess : authFail;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _isValid(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData && snapshot.data == authSuccess) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Get.to(Home());
                  },
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Click here to continue'))
            ];
          } else if (snapshot.hasData && snapshot.data == authFail) {
            children = const <Widget>[
              Icon(
                Icons.not_accessible,
                color: Colors.red,
                size: 60,
              ),
              Text('Verified Failed')
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Waiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
