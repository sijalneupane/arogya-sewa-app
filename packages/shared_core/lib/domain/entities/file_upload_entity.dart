import 'dart:io';

import 'package:shared_core/enum/file_type_enum.dart';
class FileUploadEntity {
  final File file;
  final FileType filetype;

  FileUploadEntity({required this.file, required this.filetype});
}
