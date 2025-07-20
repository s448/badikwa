// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAnswersAdapter extends TypeAdapter<UserAnswers> {
  @override
  final int typeId = 0;

  @override
  UserAnswers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAnswers(
      examId: fields[0] as String,
      answers: (fields[1] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as Map).map((dynamic k, dynamic v) => MapEntry(
              k as String,
              (v as List)
                  .map((dynamic e) => (e as List).cast<int>())
                  .toList())))),
    );
  }

  @override
  void write(BinaryWriter writer, UserAnswers obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.examId)
      ..writeByte(1)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAnswersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
