import 'package:breuninger_test/modules/github_gist_service/headline_list_service.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_block.dart';
import 'package:breuninger_test/widgets/selector_lists.dart';
import 'package:flutter/widgets.dart';

class EndpointWidget extends StatelessWidget {

  final EndpointBlock endpointBlock;

  const EndpointWidget({super.key, required this.endpointBlock});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<HeadlinesListBloc, HeadlinesListState>(
    //   builder: (context, state) {
    //     final endpointBlock = context.read<EndpointBlock>();
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: SelectorList<GitHubGistEndpoints>(
            items: [
              SelectorItem(
                value: GitHubGistEndpoints.simple,
                text: "Simple data source",
                selected: endpointBlock.state.endpoint == GitHubGistEndpoints.simple,
              ),
              SelectorItem(
                value: GitHubGistEndpoints.complex,
                text: "Complex data source",
                selected: endpointBlock.state.endpoint == GitHubGistEndpoints.complex,
              ),
            ],
            onSelect: (endpiont) {
              endpointBlock.add(ChangeEndpintEvent(endpoint: endpiont));
            },
          ),
        );
    //   },
    // );
  }
}
