
Map<String, String> languageMap = {
  'en': 'English',
  'tr': 'Turkish',
  'ar': 'Arabic',
  'es': 'Spanish', // get from database instead of hardcoding LATER
};

List<String> extractLanguages(String languageCombination) {
  List<String> languages = languageCombination.split('_');

  if (languages.length == 2) {
    String userLanguageCode = languages[0]; // First part is user's language
    String learningLanguageCode = languages[1];
    
    
    String userLanguage = languageMap[userLanguageCode] ?? 'Unknown';
    String learningLanguage = languageMap[learningLanguageCode] ?? 'Unknown'; // Second part is learning language

    return [userLanguage, learningLanguage];
  } else {
    print('Invalid language combination format!');
    return []; // Return an empty list or handle the error case as needed
  }
}
