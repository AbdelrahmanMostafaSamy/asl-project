import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error : ${response.statusCode}");
      }
    } catch (e) {
      print("Error is : $e");
    }
  }

  Future<Map<String, dynamic>?> postRequest(
      String url, Map<String, dynamic> data) async {
    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
