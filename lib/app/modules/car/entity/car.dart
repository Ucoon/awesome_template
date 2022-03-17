import 'dart:convert';

Car carFromJson(String str) => Car.fromJson(json.decode(str));

String carToJson(Car data) => json.encode(data.toJson());

class Car {
  Car({
    this.id,
    required this.brand,
    this.type = '',
    this.start = false,
  });

  int? id;
  String brand;
  String type;
  bool start;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"],
        brand: json["brand"],
        type: json["type"],
        start: json["start"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "type": type,
        "start": start ? 1 : 0,
      };
}
