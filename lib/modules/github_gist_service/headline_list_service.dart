import 'dart:async';
import 'dart:convert';
import 'package:breuninger_test/modules/breuninger_list/list_manager.dart';
import 'package:breuninger_test/common/filters.dart';
import 'package:breuninger_test/common/rest_service.dart';
import 'package:flutter/foundation.dart';


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

  GitHubGistHeadlineListServiceImpl({
    required this.restService,
    required this.endpoint,
  });

  @override
  Stream<List<HeadlinesListElement>> fetchList({
    List<FilterResult>? filters,
  }) async* {
    // TODO: Filters should be more dynamic; HeadlineList should accept a set of filters.
    final genderId =
        (filters?.first as DropDownFilterSelection?)?.id ?? Gender.all.id;

    final headlineListString = await restService.get(
      urlString: endpoint.urlString,
    );
    List<dynamic> jsonRoot = jsonDecode(headlineListString);
    List<HeadlinesListElement> headlineList = [];
    for (var h in jsonRoot) {
      try {
        switch (h['type']) {
          case 'teaser':
            headlineList.add(_parseTeaser(h));
          case 'slider':
            for (var i in (h["attributes"]["items"] as List<dynamic>)) {
              try {
                headlineList.add(_parseSliderItem(i));
              } catch (e) {
                if (kDebugMode) {
                  print('Caught an exception: $e');
                }
              }
            }

          case 'brand_slider':
            yield headlineList.where((h) {
              return genderId == Gender.all.id ? true : h.gender.id == genderId;
            }).toList();

            final itemsUrl = h['attributes']['items_url'] as String;
            final itemsString = await restService.get(urlString: itemsUrl);
            final itemsJsonRoot = jsonDecode(itemsString);
            for (var h in itemsJsonRoot['items']) {
              try {
                headlineList.add(_parseSliderItem(h));
              } catch (e) {
                if (kDebugMode) {
                  print('Caught an exception: $e');
                }
              }
            }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Caught an exception: $e');
        }
      }
    }

    yield headlineList.where((h) {
      return genderId == Gender.all.id ? true : h.gender.id == genderId;
    }).toList();
  }

  HeadlinesListElement _parseTeaser(Map<String, dynamic> h) {
    final id = h["id"];
    final url = h["attributes"]["url"];
    if (id == null) {
      throw JsonParsingFieldMissingException(message: "id is missing");
    }
    if (url == null) {
      throw JsonParsingFieldMissingException(message: "url is missing");
    }
    return HeadlinesListElement(
      id: id,
      headline: h["attributes"]["headline"],
      gender: Gender.fromId(h["gender"]),
      imageUrl: h["attributes"]["image_url"],
      url: url,
    );
  }

  HeadlinesListElement _parseSliderItem(Map<String, dynamic> h) {
    final id = h["id"];
    final url = h["url"];
    if (id == null) {
      throw JsonParsingFieldMissingException(message: "id is missing");
    }
    if (url == null) {
      throw JsonParsingFieldMissingException(message: "url is missing");
    }
    return HeadlinesListElement(
      id: id,
      headline: h["headline"],
      gender: Gender.fromId(h["gender"]),
      imageUrl: h["image_url"],
      url: url,
    );
  }
}

class JsonParsingException implements Exception {
  final String message;
  JsonParsingException({required this.message});

  @override
  String toString() => 'JsonParsingException: $message';
}

class JsonParsingFieldMissingException extends JsonParsingException {
  JsonParsingFieldMissingException({required super.message});

  @override
  String toString() => 'JsonParsingException: $message';
}
