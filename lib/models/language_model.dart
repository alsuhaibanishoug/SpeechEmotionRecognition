class LanguageModel {
  final int id;
  final String name;
  final String languageCode;

  LanguageModel(
      {required this.id, required this.name, required this.languageCode});

  static List<LanguageModel> languageList() {
    return <LanguageModel>[
      LanguageModel(id: 1, name: 'English', languageCode: 'en'),
      LanguageModel(id: 2, name: 'Arabic', languageCode: 'ar'),
    ];
  }

  static List<LanguageModel> choices = <LanguageModel>[
    LanguageModel(id: 1, name: "English", languageCode: "en"),
    LanguageModel(id: 2, name: "Arabic", languageCode: "ar"),
  ];
}
