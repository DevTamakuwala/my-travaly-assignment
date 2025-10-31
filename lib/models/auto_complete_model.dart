class AutoCompleteResponse {
  final AutoCompleteList? data;
  final bool status;
  final String message;

  AutoCompleteResponse({this.data, this.status = false, this.message = ''});

  factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutoCompleteResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data']['autoCompleteList'] != null
          ? AutoCompleteList.fromJson(json['data']['autoCompleteList'])
          : null,
    );
  }
}

class AutoCompleteList {
  final AutoCompleteCategory byPropertyName;
  final AutoCompleteCategory byStreet;
  final AutoCompleteCategory byCity;
  final AutoCompleteCategory byCountry;

  AutoCompleteList({
    required this.byPropertyName,
    required this.byStreet,
    required this.byCity,
    required this.byCountry,
  });

  factory AutoCompleteList.fromJson(Map<String, dynamic> json) {
    return AutoCompleteList(
      byPropertyName: AutoCompleteCategory.fromJson(json['byPropertyName'] ?? {}),
      byStreet: AutoCompleteCategory.fromJson(json['byStreet'] ?? {}),
      byCity: AutoCompleteCategory.fromJson(json['byCity'] ?? {}),
      byCountry: AutoCompleteCategory.fromJson(json['byCountry'] ?? {}),
    );
  }
}

class AutoCompleteCategory {
  final bool present;
  final List<AutoCompleteResult> listOfResult;

  AutoCompleteCategory({this.present = false, this.listOfResult = const []});

  factory AutoCompleteCategory.fromJson(Map<String, dynamic> json) {
    var results = <AutoCompleteResult>[];
    if (json['listOfResult'] != null && json['listOfResult'] is List) {
      results = (json['listOfResult'] as List)
          .map((item) => AutoCompleteResult.fromJson(item))
          .toList();
    }
    return AutoCompleteCategory(
      present: json['present'] ?? false,
      listOfResult: results,
    );
  }
}

class AutoCompleteResult {
  final String valueToDisplay;
  final Map<String, dynamic> address;
  final Map<String, dynamic> searchArray;

  AutoCompleteResult({
    required this.valueToDisplay,
    required this.address,
    required this.searchArray,
  });

  factory AutoCompleteResult.fromJson(Map<String, dynamic> json) {
    return AutoCompleteResult(
      valueToDisplay: json['valueToDisplay'] ?? 'Unknown',
      address: json['address'] ?? {},
      searchArray: json['searchArray'] ?? {},
    );
  }

  String get formattedAddress {
    return [
      address['street'],
      address['city'],
      address['state'],
      address['country']
    ].where((s) => s != null && s.isNotEmpty).join(', ');
  }
}
