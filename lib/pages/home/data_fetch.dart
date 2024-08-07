import 'package:cloud_firestore/cloud_firestore.dart';

class DataFetch {
  // Method to fetch intended language image (the one on the top bar)
  static Future<String> fetchIntendedLanguageImage(String? intendedLanguageId) async {
    if (intendedLanguageId == null) return 'No image';

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('intended_languages')
          .where('language', isEqualTo: intendedLanguageId)
          .get();
      final intendedLanguageData = snapshot.docs;
      if (intendedLanguageData.isNotEmpty) {
        return (intendedLanguageData.first.data() as Map<String, dynamic>)['image'] ?? 'No image';
      }
      return 'No image';
    } catch (e) {
      print('Error fetching intended language image: $e');
      return 'No image';
    }
  }

  // Method to get the available language images
  static Future<List<DocumentSnapshot>> fetchAvailableLanguages(String selectedLanguageId, String? intendedLanguageId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('intended_languages')
          .get();

      final hasDocument = snapshot.docs.any((doc) => doc.get('language') == selectedLanguageId);

      if (hasDocument) {
        final userLanguageDoc = snapshot.docs.firstWhere(
          (doc) => doc.get('language') == selectedLanguageId,
        );

        final availability = List<String>.from(userLanguageDoc.get('availability'));

        final filteredLanguages = snapshot.docs
            .where((doc) =>
                availability.contains(doc.get('language')) &&
                doc.get('language') != intendedLanguageId)
            .toList();

        return filteredLanguages;
      }
      return [];
    } catch (e) {
      print('Error fetching available languages: $e');
      return [];
    }
  }
}
