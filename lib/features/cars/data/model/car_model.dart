class CarModel {
  const CarModel({
    this.id = 0,
    this.brandId = 0,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.status,
    required this.condition,
    required this.price,
    required this.description,
  });

  final int id;
  final int brandId;
  final String name;
  final String brand;
  final String model;
  final int year;
  final String status;
  final String condition;
  final String price;
  final String description;

  factory CarModel.fromJson(Map<String, dynamic> json) {
    final brandName = json['brandName'] as String? ?? json['brand'] as String? ?? '';
    final modelName = json['modelName'] as String? ?? json['model'] as String? ?? '';

    return CarModel(
      id: json['id'] as int? ?? 0,
      brandId: json['brandId'] as int? ?? 0,
      name: '$brandName $modelName'.trim(),
      brand: brandName,
      model: modelName,
      year: json['year'] as int? ?? DateTime.now().year,
      status: json['status'] as String? ?? 'Published',
      condition: json['condition'] as String? ?? 'New',
      price: json['price']?.toString() ?? r'$0',
      description: json['description'] as String? ?? modelName,
    );
  }
}

class CreateCarRequest {
  const CreateCarRequest({required this.brandName, required this.modelName});

  final String brandName;
  final String modelName;

  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'modelName': modelName,
    };
  }
}

class UpdateCarRequest {
  const UpdateCarRequest({required this.brandId, required this.modelName});

  final int brandId;
  final String modelName;

  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'modelName': modelName,
    };
  }
}
