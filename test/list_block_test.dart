import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:breuninger_test/breuninger_list/headline_list_service.dart';
import 'package:breuninger_test/breuninger_list/list_manager.dart';
import 'package:breuninger_test/common/filters.dart';
import 'package:breuninger_test/common/rest_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breuninger_test/breuninger_list/list_block.dart';


void main() {
  group('List block', () {
    group("fetch list", () {
      test("no filters", () async {
                final blockObserver = SimpleBlocObserver(FetchList);
        Bloc.observer = blockObserver;

        final bloc = HeadlinesListBloc(
          listManager: HeadlinesListManager(
            headlineListService: GitHubGistHeadlineListServiceImpl(
              restService: RestServiceImpl(),
              endpoint: GitHubGistEndpoints.simple,
            ),
          ),
        );
        expect(bloc, isNotNull);
        bloc.add(FetchList());
        await blockObserver.waitForChange();
        final headlineList = bloc.state.headlineList.headlines;
        expect(headlineList.isNotEmpty, isTrue);
        expect(headlineList[0].id == 1, isTrue);
        expect(headlineList[1].id == 2, isTrue);
        expect(headlineList[2].id == 2442, isTrue);
        expect(headlineList[3].id == 9685, isTrue);
        expect(headlineList[4].id == 3344, isTrue);
        bloc.close();
      });

      test("filter men", () async {
        final blockObserver = SimpleBlocObserver(SetFilter);
        Bloc.observer = blockObserver;

        final bloc = HeadlinesListBloc(
          listManager: HeadlinesListManager(
            headlineListService: GitHubGistHeadlineListServiceImpl(
              restService: RestServiceImpl(),
              endpoint: GitHubGistEndpoints.simple,
            ),
          ),
        );
        expect(bloc, isNotNull);
        bloc.add(
          SetFilter(
            filterSelection: DropDownFilterSelection(
              filterId: "gender_filter",
              id: Gender.male.id,
            ),
          ),
        );
        await blockObserver.waitForChange();
        final headlineList = bloc.state.headlineList.headlines;
        expect(headlineList.isNotEmpty, isTrue);
        expect(headlineList[0].id == 1, isTrue);
        expect(headlineList[1].id == 9685, isTrue);
        bloc.close();
      });

      test("filter female", () async {
        final blockObserver = SimpleBlocObserver(SetFilter);
        Bloc.observer = blockObserver;

        final bloc = HeadlinesListBloc(
          listManager: HeadlinesListManager(
            headlineListService: GitHubGistHeadlineListServiceImpl(
              restService: RestServiceImpl(),
              endpoint: GitHubGistEndpoints.simple,
            ),
          ),
        );
        expect(bloc, isNotNull);
        bloc.add(
          SetFilter(
            filterSelection: DropDownFilterSelection(
              filterId: "gender_filter",
              id: Gender.female.id,
            ),
          ),
        );
        await blockObserver.waitForChange();
        final headlineList = bloc.state.headlineList.headlines;
        expect(headlineList.isNotEmpty, isTrue);
        expect(headlineList[0].id == 2, isTrue);
        expect(headlineList[1].id == 2442, isTrue);
        expect(headlineList[2].id == 3344, isTrue);
        bloc.close();
      });

      test("filter all genders", () async {
        final blockObserver = SimpleBlocObserver(SetFilter);
        Bloc.observer = blockObserver;

        final bloc = HeadlinesListBloc(
          listManager: HeadlinesListManager(
            headlineListService: GitHubGistHeadlineListServiceImpl(
              restService: RestServiceImpl(),
              endpoint: GitHubGistEndpoints.simple,
            ),
          ),
        );
        expect(bloc, isNotNull);
        bloc.add(
          SetFilter(
            filterSelection: DropDownFilterSelection(
              filterId: "gender_filter",
              id: Gender.all.id,
            ),
          ),
        );
        await blockObserver.waitForChange();
        final headlineList = bloc.state.headlineList.headlines;
        expect(headlineList.isNotEmpty, isTrue);
        expect(headlineList[0].id == 1, isTrue);
        expect(headlineList[1].id == 2, isTrue);
        expect(headlineList[2].id == 2442, isTrue);
        expect(headlineList[3].id == 9685, isTrue);
        expect(headlineList[4].id == 3344, isTrue);
        bloc.close();
      });
    });
  });
}


class SimpleBlocObserver extends BlocObserver {
  // final BlocBase bloc;
  final Type event;
  final Completer completer = Completer();

  SimpleBlocObserver(this.event);

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (transition.event.runtimeType == event) {
      completer.complete();
    }
  }

  Future<void> waitForChange() async {
    return completer.future;
  }
}
