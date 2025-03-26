import 'package:breuninger_test/common/rest_service.dart';

class MockRestService extends RestService {
  @override
  Future<String> get({required String urlString}) async {
    switch (urlString) {
      case "https://gist.githubusercontent.com/breunibes/6875e0b96a7081d1875ec1bd16c619f1/raw/e991c5d8f37537d917f07ebfafbba0d1708b134b/mock.json":
        return '''
[
  {
    "id": 1,
    "type": "teaser",
    "gender": "male",
    "expires_at": "2025-01-20T10:00:00.000Z",
    "attributes": {
      "headline": "new looks",
      "image_url": "https://placecats.com/300/200",
      "url": "https://www.breuninger.com/de/herren/"
    }
  },  
  {
    "id": 2,
    "type": "teaser",
    "gender": "female",
    "expires_at": "2025-01-20T10:00:00.000Z",
    "attributes": {
      "headline": "new looks",
      "image_url": "https://placecats.com/300/200",
      "url": "https://www.breuninger.com/de/herren/"
    }
  },
  {
    "id": 3,
    "type": "slider",
    "attributes": {
      "items": [
        {
          "id": 2442,
          "gender": "female",
          "expires_at": "2025-01-10T10:00:00.000Z",
          "headline": "new collection",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/accessoires/"
        },
        {
          "id": 9685,
          "gender": "male",
          "expires_at": "2024-12-25T00:00:00.000Z",
          "headline": "2025 styles",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/schuhe/"
        },
        {
          "id": 3344,
          "gender": "female",
          "expires_at": "2025-01-12T10:00:00.000Z",
          "headline": "new looks",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/luxus/"
        }
      ]
    }
  }
]
      ''';
      case "https://gist.githubusercontent.com/breunibes/bd5b65cf638fc3f67b1007721ac05205/raw/e7f9a4798d446728ba396b869af6b609a562ea03/gistfile1.txt":
        return '''
[
  {
    "id": 1,
    "type": "teaser",
    "gender": "male",
    "expires_at": "2025-01-20T10:00:00.000Z",
    "attributes": {
      "headline": "new looks",
      "image_url": "https://placecats.com/300/200",
      "url": "https://www.breuninger.com/de/herren/"
    }
  },  
  {
    "id": 2,
    "type": "teaser",
    "gender": "female",
    "expires_at": "2025-01-20T10:00:00.000Z",
    "attributes": {
      "headline": "new looks",
      "image_url": "https://placecats.com/300/200",
      "url": "https://www.breuninger.com/de/herren/"
    }
  },
  {
    "id": 3,
    "type": "slider",
    "attributes": {
      "items": [
        {
          "id": 2442,
          "gender": "female",
          "expires_at": "2025-01-10T10:00:00.000Z",
          "headline": "new collection",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/accessoires/"
        },
        {
          "id": 9685,
          "gender": "male",
          "expires_at": "2024-12-25T00:00:00.000Z",
          "headline": "2025 styles",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/schuhe/"
        },
        {
          "id": 3344,
          "gender": "female",
          "expires_at": "2025-01-12T10:00:00.000Z",
          "headline": "new looks",
          "image_url": "https://placecats.com/300/200",
          "url": "https://www.breuninger.com/de/damen/luxus/"
        }
      ]
    }
  },
  {
    "id": 4,
    "type": "brand_slider",
    "attributes": {
      "items_url": "https://gist.githubusercontent.com/breunibes/685504fa15950dea41be757f50f334a0/raw/a1fe57865871c08d7544e0bf1a89564fe698b42a/brand_items.json"
    }
  }
]
      ''';
      case 'https://gist.githubusercontent.com/breunibes/685504fa15950dea41be757f50f334a0/raw/a1fe57865871c08d7544e0bf1a89564fe698b42a/brand_items.json':
        return '''
{
  "items": [
      {
        "id": 47567,
        "gender": "female",
        "expires_at": "2025-02-10T10:00:00.000Z",
        "headline": "brand item 1",
        "image_url": "https://placecats.com/300/200",
        "url": "https://www.breuninger.com/de/damen/accessoires/"
      },
      {
        "id": 465757,
        "gender": "male",
        "expires_at": "2025-01-01T00:00:00.000Z",
        "headline": "brand item 2",
        "image_url": "https://placecats.com/300/200",
        "url": "https://www.breuninger.com/de/damen/schuhe/"
      }
    ]
}
      ''';
      default:
        break;
    }
    throw RestServiceException(message: 'Url not fount', statusCode: 404);
  }
}