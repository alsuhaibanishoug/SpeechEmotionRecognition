class LanguageModel {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  LanguageModel(
      {required this.id,
      required this.name,
      required this.flag,
      required this.languageCode});

  static List<LanguageModel> languageList() {
    return <LanguageModel>[
      LanguageModel(
          id: 1,
          name: 'English',
          flag: getCountryFlag('US'),
          languageCode: 'en'),
      LanguageModel(
          id: 2,
          name: 'Arabic',
          flag: getCountryFlag('EG'),
          languageCode: 'ar'),
    ];
  }

  static String getCountryFlag(String code) {
    return code.replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }

  static List<LanguageModel> choices = <LanguageModel>[
    LanguageModel(
        id: 1,
        name: "USA",
        flag: LanguageModel.getCountryFlag("US"),
        languageCode: "en"),

    LanguageModel(
        id: 2,
        name: "Sudia Arabia",
        flag: LanguageModel.getCountryFlag("SA"),
        languageCode: "ar"),
  ];
}
