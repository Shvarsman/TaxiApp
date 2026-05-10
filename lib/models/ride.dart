class Ride {
  final int? id;
  final String fromLocation;
  final String toLocation;
  final String tariff;
  final double price;
  final String driver;
  final int? rating;
  final DateTime timestamp;

  Ride({
    this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.tariff,
    required this.price,
    required this.driver,
    this.rating,
    required this.timestamp,
  });

  // Сериализация в Map для Hive / SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from_location': fromLocation,
      'to_location': toLocation,
      'tariff': tariff,
      'price': price,
      'driver': driver,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Десериализация из Map
  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'] as int?,
      fromLocation: map['from_location'] as String,
      toLocation: map['to_location'] as String,
      tariff: map['tariff'] as String,
      price: (map['price'] as num).toDouble(),
      driver: map['driver'] as String,
      rating: map['rating'] as int?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Ride copyWith({
    int? id,
    String? fromLocation,
    String? toLocation,
    String? tariff,
    double? price,
    String? driver,
    int? rating,
    DateTime? timestamp,
  }) {
    return Ride(
      id: id ?? this.id,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      tariff: tariff ?? this.tariff,
      price: price ?? this.price,
      driver: driver ?? this.driver,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}