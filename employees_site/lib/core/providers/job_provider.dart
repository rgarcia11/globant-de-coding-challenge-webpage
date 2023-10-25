import 'dart:async';
import 'dart:typed_data';

import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/services/jobs_service.dart';
import 'package:flutter/widgets.dart';

class JobProvider extends ChangeNotifier {
  Map<int, Job> jobsMap = {};
  List<Job> jobs = [];

  JobProvider() {
    getAllJobs();
  }

  Future<List<Job>> getAllJobs() async {
    jobs = [];
    try {
      jobs.addAll(await JobsService.getAllJobs());
    } catch (error) {
      print('Error in job_provder.getJobs: $error');
    }

    setJobs(jobs);
    notifyListeners();
    return jobs;
  }

  Job? getJobById(int id) {
    return jobsMap[id];
  }

  Future<Job?> getJobByName(String jobName) async {
    for (Job job in jobs) {
      if (job.job == jobName) {
        return job;
      }
    }
    await JobsService.createJob(Job(job: jobName));
    await getAllJobs();
    for (Job job in jobs) {
      if (job.job == jobName) {
        return job;
      }
    }
    return null;
  }

  Future<bool> uploadJobs(Uint8List fileBytes) async {
    bool res = await JobsService().uploadJobs(fileBytes);
    if (res) {
      getAllJobs();
      return true;
    }
    return false;
  }

  Future<bool> deleteAllJobs() async {
    bool res = await JobsService.deleteAllJobs();
    if (res) {
      getAllJobs();
    }
    return res;
  }

  void setJobs(List<Job> jobs) {
    for (final job in jobs) {
      if (job.id == null) {
        print('Got an job with null ID at JobProvider.setJobs');
        continue;
      } else {
        jobsMap[job.id!] = job;
      }
    }
    notifyListeners();
  }

  void deleteJob(int id) async {
    Job employee = await JobsService().deleteJob(id);
    jobs.removeWhere((element) => element.id == employee.id);
    notifyListeners();
  }

  void _terminate() async {
    jobsMap = {};
  }

  @override
  void dispose() {
    super.dispose();
    _terminate();
  }
}
