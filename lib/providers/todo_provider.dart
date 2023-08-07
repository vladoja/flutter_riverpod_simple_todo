import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_simple_todo/data/dummy_data.dart';
import 'package:riverpod_simple_todo/models/todo.dart';
import 'package:riverpod_simple_todo/providers/filter_provider.dart';

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

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todoList = ref.watch(todosProvider);
  final filterList = ref.watch(filtersProvider);

  final Filter activeFilter =
      filterList.entries.where((element) => element.value == true).first.key;
  final List<Todo> todosToDisplay = (activeFilter == Filter.all)
      ? todoList
      : (activeFilter == Filter.done)
          ? todoList.where((element) => element.isDone == true).toList()
          : todoList.where((element) => element.isDone == false).toList();
  return todosToDisplay;
});
