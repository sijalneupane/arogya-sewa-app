// Export file entities and models
export 'domain/entities/file_entity.dart';
export 'data/models/file_model.dart';

// Export doctor domain entities and models
export 'domain/enums/appointment_status_enum.dart';
export 'domain/enums/doctor_status_enum.dart';
export 'domain/entities/appointment_changed_time_entity.dart';
export 'domain/entities/appointment_entity.dart';
export 'domain/entities/patient_entity.dart';
export 'domain/entities/doctor_availability_entity.dart';
export 'domain/entities/doctor_entity.dart';
export 'domain/entities/doctor_list_entity.dart';
export 'domain/entities/doctor_detail_entity.dart';
export 'domain/entities/department_entity.dart';
export 'domain/entities/hospital_entity.dart';
export 'domain/entities/availability_query_params_entity.dart';
export 'domain/entities/doctor_availability_list_entity.dart';
export 'data/models/doctor_availability_model.dart';
export 'data/models/appointment_changed_time_model.dart';
export 'data/models/appointment_model.dart';
export 'data/models/patient_model.dart';
export 'data/models/doctor_model.dart';
export 'data/models/doctor_list_model.dart';
export 'data/models/doctor_detail_model.dart';
export 'data/models/department_model.dart';
export 'data/models/hospital_model.dart';
export 'data/models/availability_query_params_model.dart';
export 'data/models/doctor_availability_list_model.dart';

// Export location entities and models
export 'domain/entities/location_entity.dart';
export 'data/models/location_model.dart';

// Export services
export 'services/location_service.dart';

// Export utilities
export 'utils/date_formatter.dart';
export 'utils/url_launcher_utils.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
