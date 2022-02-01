import 'package:flutter/material.dart';

class Password {
  String title;
  String password;

  Password({required this.title, required this.password});

  factory Password.fromJson(Map<String, dynamic> json) =>
      Password(title: json['title'], password: json['password']);

  Map<String, dynamic> toJson() => {'title': title, 'password': password};
}
