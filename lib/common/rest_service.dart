import 'package:http/http.dart' as http;

abstract class RestService {
  Future<String> get({required String urlString});
}

class RestServiceException implements Exception {
  final String message;
  final int statusCode;
  RestServiceException({required this.message, required this.statusCode});

  @override
  String toString() => 'CustomException: $message';
}

class RestServiceImpl extends RestService {
  @override
  Future<String> get({required String urlString}) async {

    final url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw RestServiceException(
        message: 'Request failed with status: ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }
  }
}