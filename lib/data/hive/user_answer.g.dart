// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAnswerAdapter extends TypeAdapter<UserAnswer> {
  @override
  final int typeId = 0;

  @override
  UserAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAnswer(
      key: fields[0] as String,
      selectedAnswers: (fields[1] as Map).cast<int, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.selectedAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
