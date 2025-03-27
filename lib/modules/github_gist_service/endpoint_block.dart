import 'package:bloc/bloc.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_manager.dart';
import 'package:breuninger_test/modules/github_gist_service/headline_list_service.dart';

class EndpointState {
  final GitHubGistEndpoints endpoint;
  EndpointState({required this.endpoint});
}

sealed class EndpointEvent {}

class ChangeEndpintEvent extends EndpointEvent {
  final GitHubGistEndpoints endpoint;

  ChangeEndpintEvent({required this.endpoint});
}

class EndpointBlock extends Bloc<EndpointEvent, EndpointState> {
  final GitHubGistHeadlineListEndpointManager endpointManager;

  EndpointBlock({required this.endpointManager})
    : super(EndpointState(endpoint: GitHubGistEndpoints.simple)) {
    on<ChangeEndpintEvent>((event, emit) {
      endpointManager.setEndpoint(event.endpoint);
      emit(EndpointState(endpoint: event.endpoint));
    });
  }
}
