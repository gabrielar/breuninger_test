import 'package:breuninger_test/modules/github_gist_service/headline_list_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_rest_service.dart';

void main() {
  group('HeadlineListServiceImpl', () {
    group("fetchList", () {
      test("simple list", () async {
        final hls = GitHubGistHeadlineListServiceImpl(
          restService: MockRestService(),
          endpoint: GitHubGistEndpoints.simple,
        );
        await for (var headlineList in hls.fetchList()) {
          expect(headlineList[0].id == 1, isTrue);
          expect(headlineList[1].id == 2, isTrue);
          expect(headlineList[2].id == 2442, isTrue);
          expect(headlineList[3].id == 9685, isTrue);
          expect(headlineList[4].id == 3344, isTrue);
        }
      });

      test("complex list", () async {
        final hls = GitHubGistHeadlineListServiceImpl(
          restService: MockRestService(),
          endpoint: GitHubGistEndpoints.complex,
        );

        var iterationCount = 0;
        await for (var headlineList in hls.fetchList()) {
          expect(headlineList[0].id == 1, isTrue);
          expect(headlineList[1].id == 2, isTrue);
          expect(headlineList[2].id == 2442, isTrue);
          expect(headlineList[3].id == 9685, isTrue);
          expect(headlineList[4].id == 3344, isTrue);
          if (iterationCount > 0) {
            expect(headlineList[5].id == 47567, isTrue);
            expect(headlineList[6].id == 465757, isTrue);
          }
        }
      });
    });
  });
}
