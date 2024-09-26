class Hike {
  final int? id; // null when creating a new hike
  final String name;
  final String location;
  final String date;
  final String parkingAvailable;
  final String length;
  final String difficulty;
  final String description;
  final String weatherForecast;
  final String estimatedDuration;

  Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    this.description = '',
    this.weatherForecast = '',
    this.estimatedDuration = '',
  });

  // Convert Hike object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'parkingAvailable': parkingAvailable,
      'length': length,
      'difficulty': difficulty,
      'description': description,
      'weatherForecast': weatherForecast,
      'estimatedDuration': estimatedDuration,
    };
  }

  // Create a Hike object from a Map
  static Hike fromMap(Map<String, dynamic> map) {
    return Hike(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      parkingAvailable: map['parkingAvailable'],
      length: map['length'],
      difficulty: map['difficulty'],
      description: map['description'] ?? '',
      weatherForecast: map['weatherForecast'] ?? '',
      estimatedDuration: map['estimatedDuration'] ?? '',
    );
  }
}
