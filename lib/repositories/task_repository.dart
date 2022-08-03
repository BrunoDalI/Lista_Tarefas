import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

const taskListKey = 'task_list';

class TaskRepository{
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTaskList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(taskListKey) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Task.fromJson(e)).toList();
  }

  void saveTaskList(List<Task> tasks){
    final String jsonString = json.encode(tasks);
    sharedPreferences.setString(taskListKey, jsonString);
  }
}