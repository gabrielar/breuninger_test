import 'package:breuninger_test/modules/github_gist_service/headline_list_service.dart';
import 'package:breuninger_test/modules/breuninger_list/list_block.dart';
import 'package:breuninger_test/modules/breuninger_list/list_manager.dart';
import 'package:breuninger_test/common/rest_service.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_block.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/breuninger_list/breuninger_list.dart';

void main() {
  runApp(const MyApp());
}

class BreuningerAppRepository {
  late RestService restService;
  late GitHubGistHeadlineListServiceImpl headlineListService;
  late GitHubGistHeadlineListEndpointManager endpointManager;

  BreuningerAppRepository() {
    restService = RestServiceImpl();
    headlineListService = GitHubGistHeadlineListServiceImpl(
      endpoint: GitHubGistEndpoints.simple,
      restService: restService,
    );
    endpointManager = GitHubGistHeadlineListEndpointManager(
      headlineListServiceImpl: headlineListService,
    );
  }

  HeadlinesListBloc createHeadlinesListBloc() {
    return HeadlinesListBloc(
      listManager: HeadlinesListManager(
        headlineListService: headlineListService,
      ),
    )..addRefreshNotifier(refreshEventStream: endpointManager.refreshStream);
  }

  EndpointBlock createEndpointBlock() {
    return EndpointBlock(endpointManager: endpointManager);
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
                (BuildContext context) => repository.createHeadlinesListBloc(),
          ),
          BlocProvider<EndpointBlock>(
            create: (BuildContext context) => repository.createEndpointBlock(),
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
