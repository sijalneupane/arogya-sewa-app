import 'dart:io';

import 'package:shared_core/enum/file_type_enum.dart';
class FileUpdateEntity {
  final String fileId;
  final File file;
  final FileType fileType;
  
  FileUpdateEntity({required this.fileId, required this.file, required this.fileType});
}