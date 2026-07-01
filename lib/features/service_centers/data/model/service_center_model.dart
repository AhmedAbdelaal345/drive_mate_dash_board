class ServiceCenterModel {
  const ServiceCenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.servicesCount,
    required this.city,
    required this.status,
    required this.services,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final int servicesCount;
  final String city;
  final String status;
  final String services;

  String get location => address;

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as String? ?? '';
    final parts = addr.split(',');
    final extractedCity = parts.length > 1 ? parts.last.trim() : 'Cairo';
    final count = json['servicesCount'] as int? ?? 0;

    return ServiceCenterModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: addr,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0444,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 31.2357,
      phone: json['phone'] as String? ?? '',
      servicesCount: count,
      city: extractedCity,
      status: 'Operational',
      services: '$count Services',
    );
  }
}
