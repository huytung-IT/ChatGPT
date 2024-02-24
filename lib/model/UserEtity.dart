import 'package:hive/hive.dart';
part 'UserEtity.g.dart';

@HiveType(typeId: 2)
class UserEtity{
  @HiveField(0)
  String Sn_id = "";
  @HiveField(1)
  String Sn_displayName = "";
  @HiveField(2)
  String? Sn_userName;
  @HiveField(3)
  var Sn_photoUrl;
  @HiveField(4)
  String? Sn_Type;
}