import 'package:bloc/bloc.dart';
import 'package:breuninger_test/breuninger_list/headline_list_service.dart';

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

final GitHubGistHeadlineListServiceImpl headlineListService;

  EndpointBlock({required this.headlineListService}) : super(EndpointState(endpoint: GitHubGistEndpoints.simple)) {
    on<ChangeEndpintEvent>((event, emit) {
      headlineListService.endpoint = event.endpoint;
      emit(EndpointState(endpoint: event.endpoint));
    },);
  }
}
