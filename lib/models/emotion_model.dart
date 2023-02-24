import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';

class EmotionModel{
  final double value;
  final String emojy;
  final String title;
  final Color color;

  EmotionModel({required this.value,required this.emojy,required this.title , required this.color});


}

List<EmotionModel> emojiList= [
  EmotionModel(value: 1, emojy: AssetsManger.angry, title: "Angry" , color: ColorsManger.red),
  EmotionModel(value: 2, emojy: AssetsManger.sad, title: "sad" , color: ColorsManger.orange),
  EmotionModel(value: 3, emojy: AssetsManger.surprise, title: "Surprised" , color: ColorsManger.orangeLight),
  EmotionModel(value: 4, emojy: AssetsManger.happy, title: "Happy" , color: ColorsManger.blue),
  EmotionModel(value: 5, emojy: AssetsManger.neutral, title: "Neutral" , color: Colors.green),
];
