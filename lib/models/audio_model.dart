class AudioModel {
  String ? id;
  String ? text;
  String? angry;
  String? happy;
  String? neutral;
  String? sad;
  String? surprise;

  AudioModel(
      {
       required this.id,
        required this.text,
        required this.angry,
        required this.happy,
        required this.neutral,
        required this.sad,
        required this.surprise});


  AudioModel.fromJson({required Map<String, dynamic> map}){
    id = map["id"];
    text = map["text"];
    angry = map["angry"];
    happy = map["happy"];
    neutral = map["neutral"];
    sad = map["sad"];
    surprise = map["surprise"];
  }

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "angry":angry,
      "happy":happy,
      "neutral":neutral,
      "surprise":surprise,
      "text":text,
    };
  }
}