import 'package:todo/model/todo.dart';

enum TodoDetailPageOption {
  createNew,
  edit,
}

class TodoDetailPageArgs {
  TodoDetailPageOption option;
  int todoId;

  TodoDetailPageArgs(
    this.option, {
    this.todoId,
  });
}
