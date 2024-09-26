class Observation {
  final int? id;
  final int hikeId;
  final String observation;
  final DateTime timeOfObservation;
  final String? additionalComments;

  Observation({
    this.id,
    required this.hikeId,
    required this.observation,
    DateTime? timeOfObservation,
    this.additionalComments,
  }) : timeOfObservation = timeOfObservation ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hikeId': hikeId,
      'observation': observation,
      'timeOfObservation': timeOfObservation.toIso8601String(),
      'additionalComments': additionalComments,
    };
  }

  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'],
      hikeId: map['hikeId'],
      observation: map['observation'],
      timeOfObservation: DateTime.parse(map['timeOfObservation']),
      additionalComments: map['additionalComments'],
    );
  }
}