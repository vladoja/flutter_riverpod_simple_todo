import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_simple_todo/data/dummy_data.dart';
import 'package:riverpod_simple_todo/models/todo.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(dummyTodoList);

  void addTodo(Todo todo) {
    Todo? alreadyExists = state.cast<Todo?>().firstWhere(
          (element) => element!.id == todo.id,
          orElse: () => null,
        );
    if (alreadyExists == null) {
      state = [...state, todo];
    }
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>(
  (ref) => TodosNotifier(),
);
