

import 'package:cloud_firestore/cloud_firestore.dart';

class RePoint {
  double lat, lon;
  String name;

  RePoint({required this.lat, required this.lon, required this.name});

  RePoint.fromMap(Map<String, dynamic> map)
      : assert(map['lat'] != null), assert(map['lon'] != null),
        lat = double.parse(map['lat']),
        lon = double.parse(map['lon']),
        name = map['name'];

  RePoint.fromSnapshot(DocumentSnapshot snapshot)
      : lat = double.parse(snapshot['lat']),
        lon = double.parse(snapshot['lon']),
        name = snapshot['name'];

  @override
  String toString() => "RecPoint<$name, $lat:$lon>";

}

enum Points {
  plastic, metal, glass, paper, battery, bio, clothes, other
}

