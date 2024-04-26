import "package:flutter/material.dart";
import 'dart:convert';
import 'package:lingoneer_beta_0_0_1/services/firebase_services.dart';
import 'package:flutter/services.dart';

class DataLoader {
  static Future<void> loadDataToFirestore() async {
    try {
      // Read JSON files
      String subjectsJson = await rootBundle.loadString('lib/tempData/subjects.json');
      String levelsJson = await rootBundle.loadString('lib/tempData/levels.json');
      String mapCardsJson = await rootBundle.loadString('lib/tempData/mapcards.json'); // Corrected path
      String lessonsJson = await rootBundle.loadString('lib/tempData/lessons.json');
      String testsJson = await rootBundle.loadString('lib/tempData/tests.json');

      // Parse JSON
      List<Map<String, dynamic>> subjectsData = (jsonDecode(subjectsJson)['subjects'] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> levelsData = (jsonDecode(levelsJson)['levels'] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> mapCardsData = (jsonDecode(mapCardsJson)['map_cards'] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> lessonsData = (jsonDecode(lessonsJson)['lessons'] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> testsData = (jsonDecode(testsJson)['tests'] as List<dynamic>).cast<Map<String, dynamic>>();

      // Upload data to Firestore
      await FirebaseService.uploadSubjects(subjectsData);
      await FirebaseService.uploadLevels(levelsData);
      await FirebaseService.uploadMapCards(mapCardsData);
      await FirebaseService.uploadLessons(lessonsData);
      await FirebaseService.uploadTests(testsData);

      print('Data uploaded to Firestore successfully');
    } catch (e) {
      print('Error uploading data to Firestore: $e');
    }
  }
}


