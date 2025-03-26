import 'package:breuninger_test/breuninger_list/headline_list_service.dart';
import 'package:breuninger_test/breuninger_list/list_block.dart';
import 'package:breuninger_test/breuninger_list/list_manager.dart';
import 'package:breuninger_test/common/rest_service.dart';
import 'package:breuninger_test/endpoint_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'breuninger_list/breuninger_list.dart';

void main() {
  runApp(const MyApp());
}

class BreuningerAppRepository {
  late RestService restService;
  late GitHubGistHeadlineListServiceImpl headlineListService;

  BreuningerAppRepository() {
    restService = RestServiceImpl();
    headlineListService = GitHubGistHeadlineListServiceImpl(
      endpoint: GitHubGistEndpoints.simple,
      restService: restService,
    );
  }
}

final BreuningerAppRepository repository = BreuningerAppRepository();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breuninger test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HeadlinesListBloc>(
            create:
                (BuildContext context) => HeadlinesListBloc(
                  listManager: HeadlinesListManager(
                    headlineListService: repository.headlineListService,
                  ),
                ),
          ),
          BlocProvider<EndpointBlock>(
            create:
                (BuildContext context) => EndpointBlock(
                  headlineListService: repository.headlineListService,
                ),
          ),
        ],
        child: BlocBuilder<HeadlinesListBloc, HeadlinesListState>(
          builder: (context, state) {
            return BlocBuilder<EndpointBlock, EndpointState>(
              builder: (context, state) {
                return const BreuningerScreen();
              },
            );
          },
        ),
      ),
    );
  }
}
