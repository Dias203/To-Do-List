import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];

  String? taskName;
  final dateCont = TextEditingController();
  final timeCont = TextEditingController();

  bool get isValid => taskName == null && dateCont.text.isNotEmpty && timeCont.text.isNotEmpty;

  setTaskName(String value) {
    taskName = value;
    log(value.toString());
    notifyListeners();
  }

  setDate(DateTime? date) {
    if(date == null) {
      return;
    }
    log(date.toString());

    DateTime currentDate = DateTime.now();
    DateTime now = DateTime(currentDate.year, currentDate.month, currentDate.day);
    int diff = date.difference(now).inDays;
    if(diff == 0) {
      dateCont.text = 'Today';
    }
    else if(diff == 1) {
      dateCont.text = 'Tomorrow';
    }
    else{
      dateCont.text = '${date.day} - ${date.month} - ${date.year}';
    }
    notifyListeners();
  }

  setTime(TimeOfDay? time) {
    log(time.toString());
    if(time == null) {
      return;
    }
    if(time.hour == 0) {
      timeCont.text = "12:${time.minute} AM";
    }
    else if(time.hour < 12) {
      timeCont.text = '${time.hour}:${time.minute} AM';
    }
    else if(time.hour == 12) {
      timeCont.text = '${time.hour}:${time.minute} PM';
    }
    else{
      timeCont.text = '${time.hour - 12}:${time.minute} PM';
    }
    notifyListeners();
  }
  
  addTask() {
    final task = Task(taskName!, dateCont.text, timeCont.text);
    tasks.add(task);
    timeCont.clear();
    dateCont.clear();
    log(tasks.length.toString());
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      notifyListeners(); // Cập nhật UI
    }
  }
}