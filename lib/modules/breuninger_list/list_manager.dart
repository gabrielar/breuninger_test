import 'package:breuninger_test/common/filters.dart';

enum Gender {
  male("male", "Men"), female("female", "Women"), all("all", "All");
  final String id;
  final String text;
  const Gender(this.id, this.text);
  static Gender fromId(String id) {
    return Gender.values.firstWhere(
      (e) => e.name == id,
      orElse: () => Gender.male,
    );
  }
}

class HeadlinesListElement {
  final int id;
  final String headline;
  final Gender gender;
  final String imageUrl;
  final String url;

  HeadlinesListElement({
    required this.id,
    required this.headline,
    required this.gender,
    required this.imageUrl,
    required this.url,
  });
}

class HeadlineList {

  final List<HeadlinesListElement> headlines;

  /* Normally, filters will vary from list type to list type, and thus it may be 
  beneficial to get them from the backend in a real-life situation. The following 
  variable is intended to simulate that behavior.*/ 
  final Filter filter;

  HeadlineList({required this.headlines, required this.filter});
}

class HeadlinesListManager {

  final HeadlineListService _headlineListService;
  List<FilterResult> filterResults = [
    DropDownFilterSelection(filterId: "gender_filter", id: Gender.all.id)
  ];

  HeadlinesListManager({required HeadlineListService headlineListService})
    : _headlineListService = headlineListService;

  Stream<HeadlineList> fetchList({List<FilterResult>? filterResults}) async* {
    this.filterResults = filterResults ?? this.filterResults;

// TODO: Filters should be more dynamic; HeadlineList should accept a set of filters.
    final genderFilter = this.filterResults.first as DropDownFilterSelection;
    await for (var headlines in _headlineListService.fetchList(
      filters: this.filterResults,
    )) {
      yield HeadlineList(
        headlines: headlines,
        filter: _genderFilter(genderFilter),
      );
    }
  }

  DropDownFilter _genderFilter(DropDownFilterSelection selectedGender) {
    return DropDownFilter(
      id: "gender_filter",
      values: Gender.values.map((g) {
        return DropDownFilterValue(filterId: "gender_filter", id: g.id, text: g.text);
      }).toList(),
      selectedValueId: selectedGender.id,
    );
  }
}

abstract class HeadlineListService {
    Stream<List<HeadlinesListElement>> fetchList({List<FilterResult>? filters});
}

class JsonParsingException implements Exception {
  final String message;
  JsonParsingException({required this.message});

  @override
  String toString() => 'CustomException: $message';
}