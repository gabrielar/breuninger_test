import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class SelectorItem<T> {
  final T value;
  final String text;
  final bool selected;
  const SelectorItem({required this.value, required this.text, required this.selected});
}

class _SelectorPopupMenuItemChild extends StatelessWidget {
  final String text;
  final bool selected;

  const _SelectorPopupMenuItemChild({
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: selected,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Icon(Icons.check),
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class SelectorPopupMenu<T> extends StatelessWidget {
  final List<SelectorItem<T>> items;
  final Icon icon;
  final void Function(T)? onSelect;

  const SelectorPopupMenu({super.key, required this.items, required this.icon, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: (value) {
        onSelect?.call(value);
      },
      itemBuilder: (context) {
        return items.map((e) {
          return PopupMenuItem(
            value: e.value,
            child: _SelectorPopupMenuItemChild(
              text: e.text,
              selected: e.selected,
            ),
          );
        }).toList();
      },
      icon: icon,
    );
  }
}

class _SelectorListItemWidget<T> extends StatelessWidget {
  final T value;
  final String text;
  final bool selected;
  final void Function() onTap;

  const _SelectorListItemWidget({
    required this.value,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: selected,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: Icon(Icons.check),
      ),
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class SelectorList<T> extends StatelessWidget {
  final List<SelectorItem> items;
  final void Function(T) onSelect;

  const SelectorList({super.key, required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items.map((item) {
            return _SelectorListItemWidget(
              value: item.value,
              text: item.text,
              selected: item.selected,
              onTap: () => onSelect(item.value),
            );
          }).toList(),
    );
  }
}
