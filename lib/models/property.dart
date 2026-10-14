import 'dart:convert';

enum PropertyType { apartment, villa, land, shop, office }

enum DealType { sale, rent }

String propertyTypeLabel(PropertyType t) {
  switch (t) {
    case PropertyType.apartment:
      return 'آپارتمان';
    case PropertyType.villa:
      return 'ویلا';
    case PropertyType.land:
      return 'زمین';
    case PropertyType.shop:
      return 'مغازه';
    case PropertyType.office:
      return 'دفتر کار';
  }
}

String dealLabel(DealType d) {
  switch (d) {
    case DealType.sale:
      return 'فروش';
    case DealType.rent:
      return 'اجاره';
  }
}

PropertyType propertyTypeFromString(String s) {
  return PropertyType.values.firstWhere(
    (e) => e.name == s,
    orElse: () => PropertyType.apartment,
  );
}

DealType dealFromString(String s) {
  return DealType.values.firstWhere(
    (e) => e.name == s,
    orElse: () => DealType.sale,
  );
}

class Property {
  final String id;
  final String title;
  final String city;
  final String address;
  final int price; // تومان (برای اجاره: ماهانه)
  final int area; // متر مربع
  final int rooms;
  final PropertyType type;
  final DealType deal;
  final String description;
  final String phone;
  final List<String> images;
  final double lat;
  final double lng;
  final DateTime createdAt;
  final bool isUserAdded;

  const Property({
    required this.id,
    required this.title,
    required this.city,
    required this.address,
    required this.price,
    required this.area,
    required this.rooms,
    required this.type,
    required this.deal,
    required this.description,
    required this.phone,
    required this.images,
    required this.lat,
    required this.lng,
    required this.createdAt,
    this.isUserAdded = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'city': city,
        'address': address,
        'price': price,
        'area': area,
        'rooms': rooms,
        'type': type.name,
        'deal': deal.name,
        'description': description,
        'phone': phone,
        'images': images,
        'lat': lat,
        'lng': lng,
        'createdAt': createdAt.toIso8601String(),
        'isUserAdded': isUserAdded,
      };

  factory Property.fromJson(Map<String, dynamic> j) => Property(
        id: j['id'] as String,
        title: j['title'] as String,
        city: j['city'] as String,
        address: j['address'] as String,
        price: (j['price'] as num).toInt(),
        area: (j['area'] as num).toInt(),
        rooms: (j['rooms'] as num).toInt(),
        type: propertyTypeFromString(j['type'] as String),
        deal: dealFromString(j['deal'] as String),
        description: j['description'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        images: (j['images'] as List? ?? []).map((e) => e.toString()).toList(),
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ??
            DateTime.now(),
        isUserAdded: j['isUserAdded'] as bool? ?? false,
      );

  static String encodeList(List<Property> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<Property> decodeList(String raw) {
    final arr = jsonDecode(raw) as List;
    return arr.map((e) => Property.fromJson(e as Map<String, dynamic>)).toList();
  }
}
