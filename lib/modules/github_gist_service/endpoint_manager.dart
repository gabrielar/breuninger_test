import 'dart:async';

import 'package:breuninger_test/modules/github_gist_service/headline_list_service.dart';

class GitHubGistHeadlineListEndpointManager {

  final GitHubGistHeadlineListServiceImpl headlineListServiceImpl;

  final _refreshController = StreamController<GitHubGistEndpoints>.broadcast();
  Stream<void> get refreshStream { return _refreshController.stream; }

  GitHubGistHeadlineListEndpointManager({required this.headlineListServiceImpl});

  void setEndpoint(GitHubGistEndpoints endPoint) {
    _refreshController.sink.add(endPoint);
    headlineListServiceImpl.endpoint = endPoint;
  }
}