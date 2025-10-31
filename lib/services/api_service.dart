import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:my_travaly_assignment/models/auto_complete_model.dart';
import 'package:my_travaly_assignment/models/hotel_model.dart';

class ApiService {
  static const String _baseUrl = "https://api.mytravaly.com/public/v1/";
  static const String _authToken = "71523fdd8d26f585315b4233e39d9263";

  Future<Map<dynamic, dynamic>> _postRequest(Map<String, dynamic> body,
      {String? visitorToken}) async {
    final Uri url = Uri.parse(_baseUrl);
    final headers = {
      "Content-Type": "application/json",
      "authtoken": _authToken,
    };

    if (visitorToken != null) {
      headers["visitortoken"] = visitorToken;
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body);
      final status = responseBody['status'];

      bool isSuccess = false;
      if (status is bool) {
        isSuccess = status;
      } else if (status is int) {
        isSuccess = (status == 200 || status == 201);
      }

      if (isSuccess) {
        return responseBody;
      } else {
        if (kDebugMode) {
          print(
              "API Error: $status - ${responseBody['message']}");
        }
        throw Exception(
            "API returned unsuccessful status: $status - ${responseBody['message']}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Network Error: $e");
      }
      throw Exception("Failed to connect to the server: $e");
    }
  }

  Future<String?> registerDevice() async {
    final body = {
      "action": "deviceRegister",
      "deviceRegister": {
        "deviceModel": "RMX3521",
        "deviceFingerprint":
        "realme/RMX3521/RE54E2L1:13/RKQ1.211119.001/S.f1bb32-7f7fa_1:user/release-keys",
        "deviceBrand": "realme",
        "deviceId": "RE54E2L1",
        "deviceName": "RMX3521_11_C.10",
        "deviceManufacturer": "realme",
        "deviceProduct": "RMX3521",
        "deviceSerialNumber": "unknown"
      }
    };

    try {
      final response = await _postRequest(body);
      if (response['data'] != null) {
        final token = response['data']['visitorToken'];
        return token;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in registerDevice: $e");
      }
      return null;
    }
  }

  Future<List<Hotel>> fetchPopularHotels(String visitorToken) async {
    final body = {
      "action": "popularStay",
      "popularStay": {
        "limit": 10,
        "entityType": "Any",
        "filter": {
          "searchType": "byRandom",
          "searchTypeInfo": {
            "country": "India",
          }
        },
        "currency": "INR"
      }
    };

    try {
      final response = await _postRequest(body,
          visitorToken: visitorToken);
      if (response['data'] != null) {
        final List<dynamic> hotelList = response['data'];
        return hotelList.map((json) => Hotel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<AutoCompleteList?> searchAutoComplete({
    required String visitorToken,
    required String query,
  }) async {
    final body = {
      "action": "searchAutoComplete",
      "searchAutoComplete": {
        "inputText": query,
        "searchType": [
          "byCity",
          "byState",
          "byCountry",
          "byRandom",
          "byPropertyName"
        ],
        "limit": 10
      }
    };

    try {
      final response = await _postRequest(body,
          visitorToken: visitorToken);

      if (response['data'] != null &&
          response['data']['autoCompleteList'] != null) {
        final Map<String, dynamic> autoCompleteData =
        response['data']['autoCompleteList'];
        return AutoCompleteList.fromJson(autoCompleteData);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in searchAutoComplete: $e");
      }
      throw Exception(e);
    }
  }
}
