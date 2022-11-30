import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petparent/views/first_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("image");
  runApp(const MaterialApp(home: FirstPage(), debugShowCheckedModeBanner: false));
}
