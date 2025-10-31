class Hotel {
  final String name;
  final String city;
  final String state;
  final String country;
  final String? imageUrl;

  Hotel({
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> address = json['propertyAddress'] ?? {};

    return Hotel(
      name: json['propertyName'] ?? 'Unknown Hotel',
      city: address['city'] ?? 'Unknown City',
      state: address['state'] ?? 'Unknown State',
      country: address['country'] ?? 'Unknown Country',
      imageUrl: json['propertyImage'],
    );
  }
}
