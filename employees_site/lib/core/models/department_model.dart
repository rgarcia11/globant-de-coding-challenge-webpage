class Department {
  int? id;
  String department;

  Department({
    this.id,
    required this.department,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      Department(id: json['id'], department: json['department']);

  Map<String, dynamic> toJson() => {"department": department};

  bool hasFilter(String term) {
    return department.toLowerCase().contains(term.toLowerCase()) ||
        '$id'.contains(term);
  }
}
