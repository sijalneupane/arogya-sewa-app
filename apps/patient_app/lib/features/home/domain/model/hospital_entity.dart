import 'package:shared_core/domain/entities/file_entity.dart';

class HospitalEntity {
  final String hospitalId;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> contactNumber;
  final String openedDate;
  final FileEntity? logo;
  final FileEntity? license;
  final FileEntity? banner;

  const HospitalEntity({
    required this.hospitalId,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.openedDate,
    this.logo,
    this.license,
    this.banner,
  });
}
