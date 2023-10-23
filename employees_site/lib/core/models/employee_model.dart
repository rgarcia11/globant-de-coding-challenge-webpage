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
      datetime: json['datetime'],
      jobId: json['job_id'],
      departmentId: json['departmentId']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "datetime": datetime,
        "jobId": jobId,
        "departmentId": departmentId
      };
}
