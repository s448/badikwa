// Hive model for tracking login attempts
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class LoginAttempt extends HiveObject {
  @HiveField(0)
  int failedCount;

  @HiveField(1)
  DateTime? lastFailed;

  LoginAttempt({this.failedCount = 0, this.lastFailed});
}
