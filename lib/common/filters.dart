
sealed class Filter { 
  final String id;
  Filter({required this.id});
}

sealed class FilterResult { }

class None extends Filter {
  None(): super(id: "none");
}

class DropDownFilter extends Filter {
  final List<DropDownFilterValue> values;
  String? selectedValueId;
  DropDownFilter({required super.id, required this.values, this.selectedValueId});
}

class DropDownFilterValue {
  final String filterId;
  final String id;
  final String text;
  DropDownFilterValue({required this.filterId, required this.id, required this.text}); 
}

class DropDownFilterSelection extends FilterResult {
  final String filterId;
  final String id;
  DropDownFilterSelection({required this.filterId, required this.id});
}
