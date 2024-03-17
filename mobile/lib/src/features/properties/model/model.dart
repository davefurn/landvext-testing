class PropertiesModel {
  PropertiesModel({
    required this.id,
    required this.cost,
    required this.description,
    required this.image,
    required this.location,
    required this.sellingPrice,
    required this.title,
  });

  factory PropertiesModel.fromJson(Map<String, dynamic> json) =>
      PropertiesModel(
        id: json['id'],
        cost: json['cost'],
        description: json['description'],
        image: json['image'],
        location: json['location'],
        sellingPrice: json['sellingPrice'],
        title: json['title'],
      );
  final int id;
  final String image;
  final String sellingPrice;
  final String cost;
  final String? description;
  final String title;
  final String location;
}
