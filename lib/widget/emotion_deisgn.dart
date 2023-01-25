import 'package:flutter/material.dart';
import 'package:saghi/models/emotion_model.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';

class EmotionDesign extends StatelessWidget {
  final EmotionModel emotionModel;

  const EmotionDesign(this.emotionModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          emotionModel.emojy,
          width: SizeConfigManger.bodyHeight * .04,
          height: SizeConfigManger.bodyHeight * .04,
        ),
        AppText(
            text: emotionModel.title,
            color: emotionModel.color,
            fontWeight: FontWeight.w600,
            textSize: 18),
      ],
    );
  }
}
