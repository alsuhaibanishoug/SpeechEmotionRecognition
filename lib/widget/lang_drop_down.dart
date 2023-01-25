import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:saghi/models/language_model.dart';
import 'package:saghi/screens/layout/speech_to_text/cubit/speech_cubit.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import 'app_text.dart';

class CareerDropDown extends StatelessWidget {
  SpeechCubit cubit;

  CareerDropDown(this.cubit);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfigManger.bodyHeight*.02),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            alignment: Alignment.center,
            icon: Icon(Icons.arrow_drop_down),
            buttonPadding: EdgeInsetsDirectional.only(
                end: getProportionateScreenHeight(20),
                start: getProportionateScreenHeight(30)),
            buttonDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            hint: AppText(
                text: "Choose Audio Language", color: Colors.grey, textSize: 18),
            items: LanguageModel.choices
                .map((item) => DropdownMenuItem<LanguageModel>(
                      value: item,
                      child: Center(
                        child: Text(
                          item.name ?? "",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontSize: getProportionateScreenHeight(20.0),
                          ),
                        ),
                      ),
                    ))
                .toList(),
            value: cubit.choosdLangModel,
            onChanged: (value) {
              cubit.chooseLangModel(value as LanguageModel);
            },
            buttonHeight: getProportionateScreenHeight(60.0),
            buttonWidth: double.infinity,
            itemHeight: getProportionateScreenHeight(60.0),
          ),
        ));
  }
}
