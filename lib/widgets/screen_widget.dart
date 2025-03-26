import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
abstract class ScreenWidget extends StatelessWidget {
  final String title;

  const ScreenWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: actions(context),
      ),
      body: screenBody(context),
      drawer: drawer(context),
      floatingActionButton: floatingActionButton(context),
    );
  }

  Widget screenBody(BuildContext context);

  Widget? floatingActionButton(BuildContext context) {
    return null;
  }

  Widget? drawer(BuildContext context) {
    return null;
  }

  List<Widget> actions(BuildContext context) { 
    return [];
  }

}
