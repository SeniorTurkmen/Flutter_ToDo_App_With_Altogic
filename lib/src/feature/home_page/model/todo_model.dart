class ToDoModel {
  String? sId;
  String? createdAt;
  String? updatedAt;
  bool? isDone;
  String? todoTitle;

  ToDoModel({
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.isDone = false,
    this.todoTitle,
  });

  ToDoModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isDone = json['isDone'];
    todoTitle = json['todo_title'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isDone': isDone,
      'todo_title': todoTitle,
    };
  }
}
