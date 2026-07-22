import 'package:cloud_firestore/cloud_firestore.dart';


class PointsConverter {
  int? points;

  PointsConverter({required this.points});

  factory PointsConverter.fromQuerySnapshot(DocumentSnapshot doc) {
    final docData = doc.data() as Map<String, dynamic>;
    final points = docData['points'];
    if (points != null) {
      return PointsConverter(points: points);
    }
    return PointsConverter(points: null);
  }
}