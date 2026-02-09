enum FileType { profile, certificate, license }

extension FileTypeExtension on FileType {
  String get value {
    switch (this) {
      case FileType.profile:
        return 'profile';
      case FileType.certificate:
        return 'certificate';
      case FileType.license:
        return 'license';
    }
  }
}
