class MapData {
  final int? mapId;
  final String title;
  final String coordinates;
  final int? eventId;

  MapData({
    this.mapId,
    required this.title,
    required this.coordinates,
    this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'map_id': mapId,
      'title': title,
      'coordinates': coordinates,
      'event_id': eventId,
    };
  }

  factory MapData.fromMap(Map<String, dynamic> map) {
    return MapData(
      mapId: map['map_id'] as int?,
      title: map['title'] as String,
      coordinates: map['coordinates'] as String,
      eventId: map['event_id'] as int?,
    );
  }

  MapData copyWith({
    int? mapId,
    String? title,
    String? coordinates,
    int? eventId,
  }) {
    return MapData(
      mapId: mapId ?? this.mapId,
      title: title ?? this.title,
      coordinates: coordinates ?? this.coordinates,
      eventId: eventId ?? this.eventId,
    );
  }
}
