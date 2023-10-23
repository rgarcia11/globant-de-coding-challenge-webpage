class Department {
  int? id;
  String department;

  Department({
    this.id,
    required this.department,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      Department(id: json['id'], department: json['department']);

  Map<String, dynamic> toJson() => {"id": id, "department": department};
}
