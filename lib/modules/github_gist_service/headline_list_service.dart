import 'dart:async';
import 'dart:convert';
import 'package:breuninger_test/modules/breuninger_list/list_manager.dart';
import 'package:breuninger_test/common/filters.dart';
import 'package:breuninger_test/common/rest_service.dart';


enum GitHubGistEndpoints {
  simple(
    urlString:
        "https://gist.githubusercontent.com/breunibes/6875e0b96a7081d1875ec1bd16c619f1/raw/e991c5d8f37537d917f07ebfafbba0d1708b134b/mock.json",
  ),
  complex(
    urlString:
        "https://gist.githubusercontent.com/breunibes/bd5b65cf638fc3f67b1007721ac05205/raw/e7f9a4798d446728ba396b869af6b609a562ea03/gistfile1.txt",
  );

  final String urlString;

  const GitHubGistEndpoints({required this.urlString});
}

class GitHubGistHeadlineListServiceImpl extends HeadlineListService {

  final RestService restService;
  GitHubGistEndpoints endpoint;

  GitHubGistHeadlineListServiceImpl({required this.restService, required this.endpoint});

  @override
  Stream<List<HeadlinesListElement>> fetchList({List<FilterResult>? filters}) async* {
    // TODO: Filters should be more dynamic; HeadlineList should accept a set of filters.
    final genderId = (filters?.first as DropDownFilterSelection?)?.id ?? Gender.all.id;

    final headlineListString = await restService.get(urlString: endpoint.urlString);
    List<dynamic> jsonRoot = jsonDecode(headlineListString);
    List<HeadlinesListElement> headlineList = [];
    for (var h in jsonRoot) {
      if (h['type'] == 'teaser') {
        headlineList.add(_parseTeaser(h));
      }
      if (h['type'] == 'slider') {
        for (var i in (h["attributes"]["items"] as List<dynamic>)) {
          headlineList.add(_parseSliderItem(i));
        }
      }
      if (h['type'] == 'brand_slider') {
        yield headlineList.where((h) {
          return genderId == Gender.all.id ? true : h.gender.id == genderId;
        }).toList();

        final itemsUrl = h['attributes']['items_url'] as String;
        final itemsString = await restService.get(urlString: itemsUrl);
        final itemsJsonRoot = jsonDecode(itemsString);
        for (var h in itemsJsonRoot['items']) {
          headlineList.add(_parseSliderItem(h));
        }
      }
    }

    yield headlineList.where((h) {
      return genderId == Gender.all.id ? true : h.gender.id == genderId;
    }).toList();
  }

  HeadlinesListElement _parseTeaser(Map<String, dynamic> h) {
    return HeadlinesListElement(
      id: h["id"],
      headline: h["attributes"]["headline"],
      gender: Gender.fromId(h["gender"]),
      imageUrl: h["attributes"]["image_url"],
      url: h["attributes"]["url"],
    );
  }

  HeadlinesListElement _parseSliderItem(Map<String, dynamic> h) {
    return HeadlinesListElement(
      id: h["id"],
      headline: h["headline"],
      gender: Gender.fromId(h["gender"]),
      imageUrl: h["image_url"],
      url: h["url"],
    );
  }
}
