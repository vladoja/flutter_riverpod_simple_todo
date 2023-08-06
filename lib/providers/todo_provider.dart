import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_simple_todo/data/dummy_data.dart';

final todosProvider = Provider(
  (ref) => dummyTodoList,
);
