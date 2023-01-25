import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import '../../shared/helper/mangers/size_config.dart';
import '../shared/helper/mangers/colors.dart';

class CustomTextFormField extends StatelessWidget {
  bool isPassword;
  TextInputType? type;
  dynamic validate;
  dynamic onTap;
  dynamic onChange;
  dynamic onSuffixPressed;
  var controller;
  IconData? suffixIcon;
  String? hintText;
  String? prefix;
  Color? prefixIconColor;
  bool? isEnable;
  int? maxLines;
  double hintSize;
  TextAlign? textAlign;
  double? textSize;
  List<TextInputFormatter>? inputFormatters;

  CustomTextFormField(
      {this.isPassword = false,
      this.type = TextInputType.text,
      this.validate,
      this.onChange,
      this.textSize,
      this.textAlign,
      this.onTap,
      this.hintSize = 22,
      this.maxLines = 1,
      this.suffixIcon,
      this.onSuffixPressed,
      this.controller,
      this.isEnable = true,
      this.prefixIconColor,
      this.hintText,
      this.inputFormatters,
      this.prefix});

  @override
  Widget build(BuildContext context) {
/*
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize ?? getProportionateScreenHeight(25),
          fontFamily: ConstantsManger.appFont,
        ),
        controller: controller,
        obscureText: isPassword == true ? true : false,
        keyboardType: type,
        inputFormatters: inputFormatters,
        enabled: isEnable,
        maxLines: maxLines,
        validator: validate,
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChange,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: getProportionateScreenHeight(hintSize),
            fontFamily: ConstantsManger.appFont,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: getProportionateScreenHeight(hintSize),
            fontFamily: ConstantsManger.appFont,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: IconButton(
            icon: Icon(
              suffixIcon,
              color: ColorsManger.darkPrimary,
            ),
            onPressed: onSuffixPressed,
          ),
          prefixIcon: prefix == null
              ? null
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image(
                    image: AssetImage(
                      prefix!,
                    ),
                    height: getProportionateScreenHeight(20),
                    width: getProportionateScreenHeight(20),
                  ),
                ),
        ),
      ),
    );
*/

    return TextFormField(
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: Colors.black,
        fontSize: textSize ?? getProportionateScreenHeight(25),
        fontFamily: ConstantsManger.appFont,
      ),
      controller: controller,
      obscureText: isPassword == true ? true : false,
      keyboardType: type,
      inputFormatters: inputFormatters,
      enabled: isEnable,
      maxLines: maxLines,
      validator: validate,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        hintText: hintText,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: getProportionateScreenHeight(hintSize),
          fontFamily: ConstantsManger.appFont,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: getProportionateScreenHeight(hintSize),
          fontFamily: ConstantsManger.appFont,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
            color: ColorsManger.darkPrimary,
          ),
          onPressed: onSuffixPressed,
        ),
        prefixIcon: prefix == null
            ? null
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image(
                  image: AssetImage(
                    prefix!,
                  ),
                  height: getProportionateScreenHeight(20),
                  width: getProportionateScreenHeight(20),
                ),
              ),
      ),
    );

  }
}
