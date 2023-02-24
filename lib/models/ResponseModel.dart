class ResponseModel {
  ResponseModel({
    this.angry,
    this.happy,
    this.neutral,
    this.sad,
    this.surprise,
    this.text,
    this.lang,
  });

  ResponseModel.fromJson(dynamic json) {
    angry = json['angry'];
    happy = json['happy'];
    neutral = json['neutral'];
    sad = json['sad'];
    surprise = json['surprise'];
    text = json['text'];
  }

  String? angry;
  String? happy;
  String? neutral;
  String? sad;
  String? surprise;
  String? text;
  String? lang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['angry'] = angry;
    map['happy'] = happy;
    map['neutral'] = neutral;
    map['sad'] = sad;
    map['surprise'] = surprise;
    map['text'] = text;
    return map;
  }

  double formartdouble({required value}) {
    return 0;
  }
}
