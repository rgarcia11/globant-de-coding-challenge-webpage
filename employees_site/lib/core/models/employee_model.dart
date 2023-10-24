import 'dart:io';

class Employee {
  int? id;
  String name;
  DateTime datetime;
  int jobId;
  int departmentId;

  Employee({
    this.id,
    required this.name,
    required this.datetime,
    required this.jobId,
    required this.departmentId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
      id: json['id'],
      name: json['name'],
      datetime: json['datetime'] == null
          ? DateTime.now()
          : HttpDate.parse(json['datetime']),
      jobId: json['job_id'],
      departmentId: json['department_id']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "datetime": HttpDate.format(datetime),
        "job_id": jobId,
        "department_id": departmentId
      };
}
