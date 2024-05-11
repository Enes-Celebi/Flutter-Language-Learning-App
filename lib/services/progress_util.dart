import 'package:cloud_firestore/cloud_firestore.dart';

double calculateProgressValue(List<QueryDocumentSnapshot<Map<String, dynamic>>> levels, List<QueryDocumentSnapshot<Map<String, dynamic>>> progressSnapshot) {
  final doneLevelsIds = progressSnapshot.map((doc) => doc['lessonId'].toString().substring(0, doc['lessonId'].toString().length - 3)).toSet();

  int totalLevels = levels.length;
  int doneLevelsCount = 0;
  for (var level in levels) {
    final levelId = level['id'];
    if (doneLevelsIds.contains(levelId)) {
      doneLevelsCount++;
    }
  }
  return doneLevelsCount / totalLevels;
}

