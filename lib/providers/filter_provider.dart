import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter { all, open, done }

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({Filter.all: true, Filter.open: false, Filter.done: false});

  void setFilter(Filter filter, bool activate) {
    Map<Filter, bool> newState = {...state};

    newState.updateAll((key, value) => false);
    state = {...newState, filter: activate};
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
        (ref) => FilterNotifier());
