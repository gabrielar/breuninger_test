import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:breuninger_test/common/filters.dart';
import 'list_manager.dart';

sealed class ListEvent {}
final class FetchList extends ListEvent {}
final class SetFilter extends ListEvent {
  final DropDownFilterSelection filterSelection;
  SetFilter({required this.filterSelection});
}

class HeadlinesListBloc extends Bloc<ListEvent, HeadlinesListState> {
  final HeadlinesListManager listManager;
  List<StreamSubscription<void>> _refreshSubscriptions = [];

  HeadlinesListBloc({required this.listManager})
    : super(
        HeadlinesListState(headlineList: HeadlineList(headlines: [], filter: None())),
      ) {
    on<FetchList>((event, emit) async {
      await emit.forEach(
        listManager.fetchList(),
        onData: (list) => HeadlinesListState(headlineList: list),
      );
    });

    on<SetFilter>((event, emit) async {
      await emit.forEach(
        listManager.fetchList(filterResults: [event.filterSelection]),
        onData: (list) => HeadlinesListState(headlineList: list),
      );
    });

    add(FetchList());
  }

  void addRefreshNotifier({required Stream<void> refreshEventStream}) {
    _refreshSubscriptions.add(refreshEventStream.listen((_) {
      add(FetchList());
    }));
  }
}

class HeadlinesListState {
  final HeadlineList headlineList;
  const HeadlinesListState({required this.headlineList});
}
