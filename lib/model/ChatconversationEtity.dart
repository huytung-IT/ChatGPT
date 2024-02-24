import 'package:hive/hive.dart';
part 'ChatconversationEtity.g.dart';

@HiveType(typeId: 0)
class ChatconversationEtity{
  @HiveField(0)
  String id = "";
  @HiveField(1)
  int status = 0; // 0: mới, 1: đang chat, 2: đóng (close)
  @HiveField(2)
  String title='' ;
  @HiveField(3)
  String suggestName="";
  @HiveField(4)
  String? userId;
}