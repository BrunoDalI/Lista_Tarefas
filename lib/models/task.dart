
class Task{
  Task({required this.title, required this.dateTime});

  Task.fromJson(Map<String, dynamic> json) :
        title = json['title'],
        dateTime = DateTime.parse(json['datetime'].toString());

  String title;
  DateTime dateTime;

  Map<String, dynamic> taskJson(){
    return {
      'title': title,
      'datetime': dateTime.toString(),
    };
  }
}