import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FirebaseService {
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (error) {
      print('Error initializing Firebase: $error');
    }
  }

  static Future<void> uploadDataToFirestore(String collection, List<Map<String, dynamic>> dataList) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      dataList.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection(collection).doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Data uploaded to Firestore');
    } catch (error) {
      print('Error uploading data to Firestore: $error');
    }
  }

  static Future<void> loadDataToFirestore() async {
    try {
      // Read JSON files
      String subjectsJson = await rootBundle.loadString('assets/subjects.json');
      String levelsJson = await rootBundle.loadString('assets/levels.json');
      String mapCardsJson = await rootBundle.loadString('assets/map_cards.json');
      String lessonsJson = await rootBundle.loadString('assets/lessons.json');
      String testsJson = await rootBundle.loadString('assets/tests.json');

      // Parse JSON
      List<Map<String, dynamic>> subjectsData = List<Map<String, dynamic>>.from(jsonDecode(subjectsJson));
      List<Map<String, dynamic>> levelsData = List<Map<String, dynamic>>.from(jsonDecode(levelsJson));
      List<Map<String, dynamic>> mapCardsData = List<Map<String, dynamic>>.from(jsonDecode(mapCardsJson));
      List<Map<String, dynamic>> lessonsData = List<Map<String, dynamic>>.from(jsonDecode(lessonsJson));
      List<Map<String, dynamic>> testsData = List<Map<String, dynamic>>.from(jsonDecode(testsJson));

      // Upload data to Firestore
      await uploadDataToFirestore('subjects', subjectsData);
      await uploadDataToFirestore('levels', levelsData);
      await uploadDataToFirestore('map_cards', mapCardsData);
      await uploadDataToFirestore('lessons', lessonsData);
      await uploadDataToFirestore('tests', testsData);

      print('Data uploaded to Firestore successfully');
    } catch (error) {
      print('Error uploading data to Firestore: $error');
    }
  }
  
  static Future<void> uploadSubjects(List<Map<String, dynamic>> subjectsData) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      subjectsData.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('subjects').doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Subjects uploaded to Firestore');
    } catch (error) {
      print('Error uploading subjects to Firestore: $error');
    }
  }
  
  static Future<void> uploadLevels(List<Map<String, dynamic>> levelsData) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      levelsData.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('levels').doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Levels uploaded to Firestore');
    } catch (error) {
      print('Error uploading levels to Firestore: $error');
    }
  }
  
  static Future<void> uploadMapCards(List<Map<String, dynamic>> mapCardsData) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      mapCardsData.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('map_cards').doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Map cards uploaded to Firestore');
    } catch (error) {
      print('Error uploading map cards to Firestore: $error');
    }
  }
  
  static Future<void> uploadLessons(List<Map<String, dynamic>> lessonsData) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      lessonsData.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('lessons').doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Lessons uploaded to Firestore');
    } catch (error) {
      print('Error uploading lessons to Firestore: $error');
    }
  }
  
  static Future<void> uploadTests(List<Map<String, dynamic>> testsData) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      testsData.forEach((data) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('tests').doc();
        batch.set(docRef, data);
      });
      await batch.commit();
      print('Tests uploaded to Firestore');
    } catch (error) {
      print('Error uploading tests to Firestore: $error');
    }
  }
}
