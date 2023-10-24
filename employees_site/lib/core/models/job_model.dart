class Job {
  int? id;
  String job;

  Job({
    this.id,
    required this.job,
  });

  factory Job.fromJson(Map<String, dynamic> json) =>
      Job(id: json['id'], job: json['job']);

  Map<String, dynamic> toJson() => {"job": job};
}
