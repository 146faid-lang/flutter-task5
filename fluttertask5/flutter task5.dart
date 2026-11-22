import 'dart:io';

abstract class Person {
  final String name;
  final int age;

  const Person(this.name, this.age);

  void displayInfo();
}

class Doctor extends Person {
  final String specialization;

  const Doctor(super.name, super.age, this.specialization);

  @override
  void displayInfo() {
    print('Doctor: $name | Age: $age | Specialization: $specialization');
  }
}

class Patient extends Person {
  String _patientId = '';
  Doctor? _doctor;

  Patient(super.name, super.age, String patientId) {
    this.patientId = patientId;
  }

  Patient.guest() : super('Guest', 0) {
    _patientId = 'GUEST';
  }

  String get patientId => _patientId;

  set patientId(String id) {
    if (id.trim().isEmpty) {
      print('Error: patient ID cannot be empty.');
    } else {
      _patientId = id.trim();
    }
  }

  void bookAppointment(Doctor doctor) {
    _doctor = doctor;
  }

  @override
  void displayInfo() {
    String doctorName = _doctor == null ? 'No doctor assigned' : _doctor!.name;
    print('Patient: $name | Age: $age | ID: $_patientId | Doctor: $doctorName');
  }
}

class Hospital {
  List<Doctor> doctors = [];
  List<Patient> patients = [];

  void addDoctor(Doctor doctor) {
    doctors.add(doctor);
    print('Doctor added successfully.');
  }

  void addPatient(Patient patient) {
    for (var p in patients) {
      if (p.patientId == patient.patientId) {
        print('Error: this patient ID already exists.');
        return;
      }
    }
    patients.add(patient);
    print('Patient added successfully.');
  }

  void displayDoctors() {
    if (doctors.isEmpty) {
      print('No doctors available.');
      return;
    }
    for (var doctor in doctors) {
      doctor.displayInfo();
    }
  }

  void displayPatients() {
    if (patients.isEmpty) {
      print('No patients available.');
      return;
    }
    for (var patient in patients) {
      patient.displayInfo();
    }
  }

  void bookAppointment(String patientId, String doctorName) {
    Patient? foundPatient;
    Doctor? foundDoctor;

    for (var p in patients) {
      if (p.patientId == patientId) {
        foundPatient = p;
      }
    }

    for (var d in doctors) {
      if (d.name.toLowerCase() == doctorName.toLowerCase()) {
        foundDoctor = d;
      }
    }

    if (foundPatient == null) {
      print('Error: patient ID not found.');
    } else if (foundDoctor == null) {
      print('Error: doctor name not found.');
    } else {
      foundPatient.bookAppointment(foundDoctor);
      print('Appointment booked for ${foundPatient.name} with Dr. ${foundDoctor.name}.');
    }
  }
}

String readText(String message) {
  stdout.write(message);
  String? input = stdin.readLineSync();
  return input == null ? '' : input.trim();
}

int readAge(String message) {
  while (true) {
    int? age = int.tryParse(readText(message));
    if (age != null && age > 0) {
      return age;
    }
    print('Please enter a valid age.');
  }
}

void main() {
  Hospital hospital = Hospital();
  bool running = true;

  while (running) {
    print('\n===== Hospital Management System =====\n');
    print('1. Add Doctor');
    print('2. Add Patient');
    print('3. Display Doctors');
    print('4. Display Patients');
    print('5. Book Appointment');
    print('6. Exit\n');

    String choice = readText('Choose an option: ');

    switch (choice) {
      case '1':
        String name = readText('Doctor name: ');
        int age = readAge('Doctor age: ');
        String specialization = readText('Specialization: ');
        if (name.isEmpty || specialization.isEmpty) {
          print('Error: name and specialization are required.');
        } else {
          hospital.addDoctor(Doctor(name, age, specialization));
        }
        break;

      case '2':
        String name = readText('Patient name: ');
        int age = readAge('Patient age: ');
        String id = readText('Patient ID: ');
        if (name.isEmpty) {
          print('Error: name is required.');
        } else if (id.isEmpty) {
          print('Error: patient ID cannot be empty.');
        } else {
          hospital.addPatient(Patient(name, age, id));
        }
        break;

      case '3':
        hospital.displayDoctors();
        break;

      case '4':
        hospital.displayPatients();
        break;

      case '5':
        if (hospital.doctors.isEmpty || hospital.patients.isEmpty) {
          print('You need at least one doctor and one patient first.');
        } else {
          String id = readText('Patient ID: ');
          String doctorName = readText('Doctor name: ');
          hospital.bookAppointment(id, doctorName);
        }
        break;

      case '6':
        print('Goodbye!');
        running = false;
        break;

      default:
        print('Invalid option, try again.');
    }
  }
}