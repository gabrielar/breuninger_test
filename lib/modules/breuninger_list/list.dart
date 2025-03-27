import 'package:breuninger_test/modules/breuninger_list/list_block.dart';
import 'package:breuninger_test/common/filters.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_block.dart';
import 'package:breuninger_test/modules/github_gist_service/endpoint_widget.dart';
import 'package:breuninger_test/widgets/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/cupertino.dart';
import '../../widgets/screen_widget.dart';
import '../../widgets/selector_lists.dart';


class BreuningerScreen extends ScreenWidget {
  final EndpointWidgetProvider endpointWidgetProvider;

  const BreuningerScreen({super.key, required this.endpointWidgetProvider}) : super(title: "Headlines list");

  @override
  Widget screenBody(BuildContext context) {
    return BreuningerList();
  }

  @override
  Widget? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _endpointButtonPressed(context),
      tooltip: 'Increment',
      child: const Icon(Icons.settings),
    );
  }

  @override
  List<Widget> actions(BuildContext context) {
    return [
      BlocBuilder<HeadlinesListBloc, HeadlinesListState>(
        builder: (context, state) {
          final block = context.read<HeadlinesListBloc>();
          switch (state.headlineList.filter) {
            case None _:
              return SizedBox.shrink();
            case DropDownFilter f:
              return SelectorPopupMenu(
                items: f.values.map((fv) {
                  return SelectorItem(value: fv, text: fv.text, selected: fv.id == f.selectedValueId);
                }).toList(),
                icon: Icon(Icons.filter_list),
                onSelect: (fv) {
                  if (kDebugMode) {
                    print('Selected: ${fv.text}');
                  }
                  block.add(SetFilter(filterSelection: DropDownFilterSelection(filterId: fv.filterId, id: fv.id)));
                },
              );
          }
        },
      ),
    ];
  }

  void _endpointButtonPressed(BuildContext context) {
    // final endpointBlock = context.read<EndpointBlock>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return endpointWidgetProvider.createEndpointWidget();
      },
    );
  }
}

class BreuningerList extends StatelessWidget {
  const BreuningerList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesListBloc, HeadlinesListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context.read<HeadlinesListBloc>()),
          child: ListView.builder(
            itemCount: state.headlineList.headlines.length,
            itemBuilder: (context, index) {
              final listElement = state.headlineList.headlines[index];
              return BreuningerListItem(
                key: Key('BreuningerListItem_${listElement.id}'),
                imageUrl: listElement.imageUrl,
                text: listElement.headline,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(block) async {
    await block.add(FetchList());
  }
}

class BreuningerListItem extends StatelessWidget {
  final String imageUrl;
  final String text;

  const BreuningerListItem({
    super.key,
    required this.imageUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.contain, // Optional: how the image should be inscribed into the space
            width: 50, // Optional
            height: 50, // Optional
          ),
          SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}
