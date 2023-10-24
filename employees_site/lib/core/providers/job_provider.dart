import 'dart:async';

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

  void _terminate() async {
    jobsMap = {};
  }

  @override
  void dispose() {
    super.dispose();
    _terminate();
  }
}
