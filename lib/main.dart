import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'as path_provider;
import 'package:hive/hive.dart';
import 'ChatConversationRepository.dart';
import 'ChatServices.dart';
import 'Login.dart';
void main() async {
  await Hive.initFlutter();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await ChatServices.initHive();
  final chatConversationRepository =ChatConversationRepository();
  await chatConversationRepository.init();


  runApp(const GptApp());
}
class GptApp extends StatelessWidget {
  const GptApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: Login(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
