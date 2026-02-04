class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;

  Doctor(this.id, this.name, this.specialty, this.hospital);
}
// Mock Data
final List<Doctor> allDoctors = [
    Doctor('d001', 'Dr. Alex Bennett', 'Cardiology', 'City General Hospital'),
    Doctor('d002', 'Dr. Sarah Chen', 'Pediatrics', 'Children\'s Clinic'),
    Doctor('d003', 'Dr. Michael Diaz', 'Orthopedics', 'Rehab & Bones Center'),
    Doctor('d004', 'Dr. Emily Foster', 'Neurology', 'Metro Health System'),
    Doctor('d005', 'Dr. John Gomez', 'Dermatology', 'City General Hospital'),
    Doctor('d006', 'Dr. Lily Hayes', 'Oncology', 'Regional Cancer Center'),
    Doctor('d007', 'Dr. Omar King', 'Gastroenterology', 'Metro Health System'),
];