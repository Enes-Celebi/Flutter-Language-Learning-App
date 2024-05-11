import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String? _selectedLanguage; 
  String? _intendedSelectedLanguage;
  String? _languageComb;

  String? get selectedLanguage => _selectedLanguage; 
  String? get intendedSelectedLanguage => _intendedSelectedLanguage;
  String? get languageComb => _languageComb;

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    _updateCombinedLanguage();
    print('Selected language: $language');
    notifyListeners(); // Notify listeners about the change
  }

  void setIntendedSelectedLanguage(String language) {
    _intendedSelectedLanguage = language;
    _updateCombinedLanguage();
    print('Selected language: $language');
    notifyListeners();
  }

  void _updateCombinedLanguage() {
    // Get selected language with null check and provide default value if null
    String selectedLanguage = _selectedLanguage ?? '';
    // Get intended selected language with null check and provide default value if null
    String intendedSelectedLanguage = _intendedSelectedLanguage ?? '';

    // Check if both selectedLanguage and intendedSelectedLanguage are not empty
    if (selectedLanguage.isNotEmpty && intendedSelectedLanguage.isNotEmpty) {
      _languageComb = '$selectedLanguage' + '_' + '$intendedSelectedLanguage';
      print('Language Combination: $_languageComb');
    } else {
      print('Combined language cannot be formed yet.');
    }
  }

  Future<String?> getIntendedLanguageImageURL() async {
    try {
      _updateCombinedLanguage();

      print('Intended selected language: $_intendedSelectedLanguage');

      if (_intendedSelectedLanguage != null && _intendedSelectedLanguage!.isNotEmpty) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('languages')
          .where('language', isEqualTo: _intendedSelectedLanguage)
          .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot document = snapshot.docs.first;
          return document['image'] as String?;
        } else {
          print('Language document with language $_intendedSelectedLanguage not found.');
          return null;
        }
      } else {
        print('Intended selected language is empty.');
        return null;
      }
    } catch (e) {
      print('Error fetching langugae image URL: $e');
      return null;
    }
  }
}
