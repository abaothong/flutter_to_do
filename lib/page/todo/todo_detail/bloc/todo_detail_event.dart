part of 'todo_detail_bloc.dart';

abstract class TodoDetailEvent extends Equatable {
  const TodoDetailEvent();
}

class LoadTodoEvent extends TodoDetailEvent {
  final int id;
  const LoadTodoEvent({this.id});

  @override
  List<Object> get props => ["LoadTodoEvent: $id"];
}

class SaveTodoEvent extends TodoDetailEvent {
  final Todo todo;
  final int id;

  const SaveTodoEvent(this.todo, {this.id});

  @override
  List<Object> get props => ["SaveTodoEvent: $todo"];
}
