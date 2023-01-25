import 'package:flutter/material.dart';
import 'package:saghi/main_layout/cubit/main_cubit.dart';
import 'package:saghi/models/audio_model.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';

import '../../../../widget/app_text.dart';

class FavItemDesign extends StatelessWidget {
  final AudioModel model;
  final MainCubit cubit;

  const FavItemDesign({Key? key, required this.model,required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(10),vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(20))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AppText(
                text: model.text ?? "",
                textSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                maxLines: 20,
              )),
              IconButton(
                onPressed: () {
                  cubit.deleteAudio(id:"${model.id}" );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
