import 'package:freezed_annotation/freezed_annotation.dart';

part 'people.freezed.dart';
part 'people.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required int id,
    required String name,
    @Default(false) bool isSuperUser,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
} 