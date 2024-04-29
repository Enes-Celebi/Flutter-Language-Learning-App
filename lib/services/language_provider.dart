import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String? _selectedLanguage; // Private variable to store the selected language
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
}
