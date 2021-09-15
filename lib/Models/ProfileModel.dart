import 'package:json_annotation/json_annotation.dart';

part "ProfileModel.g.dart";

@JsonSerializable()
class ProfileModel {
  String name;
  String username;
  String profession;
  // ignore: non_constant_identifier_names
  String DOB;
  String titleline;
  String about;
  ProfileModel(
      // ignore: non_constant_identifier_names
      {required this.DOB,
      required this.about,
      required this.name,
      required this.profession,
      required this.titleline,
      required this.username});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
