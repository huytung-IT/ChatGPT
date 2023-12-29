import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'as path_provider;
import 'package:hive/hive.dart';
import 'ChatConversationRepository.dart';
import 'ChatScreen.dart';
import 'ChatServices.dart';
void main() async {
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
        child: ChatScreen(conversationId: ''),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
