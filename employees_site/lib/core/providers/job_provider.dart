import 'dart:async';
import 'dart:typed_data';

import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/services/jobs_service.dart';
import 'package:flutter/widgets.dart';

class JobProvider extends ChangeNotifier {
  Map<int, Job> jobsMap = {};
  List<Job> jobs = [];
  List<Job> newJobs = [];
  List<Job> filteredJobs = [];

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
    filteredJobs = jobs;
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
    Job newJob = await JobsService.createJob(Job(job: jobName));
    jobs = [newJob, ...jobs];
    newJobs.add(newJob);
    setJobs([newJob]);
    notifyListeners();
    return newJob;
    // await getAllJobs();
    // for (Job job in jobs) {
    //   if (job.job == jobName) {
    //     return job;
    //   }
    // }
    // return null;
  }

  void filter(String? term) {
    if (term == null || term.trim().isEmpty) {
      filteredJobs = jobs;
    } else {
      filteredJobs = [];
      for (Job job in jobs) {
        if (job.hasFilter(term)) {
          filteredJobs.add(job);
        }
      }
    }
    notifyListeners();
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

  Future<void> createJob(Job newJob) async {
    jobs = [newJob, ...jobs];
    newJobs.add(newJob);
    setJobs([newJob]);
    notifyListeners();
  }

  bool isANewJob(int jobId) {
    return newJobs.fold(false, (isANewJob, Job e) {
      if (isANewJob || e.id == jobId) {
        return true;
      }
      return false;
    });
  }

  void deleteJob(int id) async {
    Job job = await JobsService().deleteJob(id);
    jobs.removeWhere((element) => element.id == job.id);
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
