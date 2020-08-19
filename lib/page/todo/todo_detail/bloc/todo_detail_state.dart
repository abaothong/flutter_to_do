part of 'todo_detail_bloc.dart';

abstract class TodoDetailState extends Equatable {
  const TodoDetailState();

  // not all state need to update ui, so limit it
  bool invokeBuild() => false;
}

class TodoDetailInitial extends TodoDetailState {
  @override
  List<Object> get props => [];
}

class BeginLoadTodoDetailState extends TodoDetailState {
  @override
  List<Object> get props => ["BeginLoadTodoDetailState"];
}

class EndLoadTodoDetailState extends TodoDetailState {
  @override
  List<Object> get props => ["EndLoadTodoDetailState"];
}

class ShowTodoDetailState extends TodoDetailState {
  final Todo todo;
  ShowTodoDetailState(this.todo);

  @override
  bool invokeBuild() => true;

  @override
  List<Object> get props => ["EndLoadTodoDetailState"];
}

class SaveTodoDoneState extends TodoDetailState {
  final bool isCreateNew;
  SaveTodoDoneState(this.isCreateNew);

  @override
  // TODO: implement props
  List<Object> get props => ["SaveTodoDoneState"];
}

class PopErrorMessageState extends TodoDetailState {
  final String errorMessage;
  PopErrorMessageState(this.errorMessage);

  @override
  // TODO: implement props
  List<Object> get props => ["PopErrorMessageState"];
}