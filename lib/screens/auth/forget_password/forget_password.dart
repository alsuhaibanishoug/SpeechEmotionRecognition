import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/screens/auth/forget_password/cubit/forget_cubit.dart';
import 'package:saghi/screens/auth/login/login_screen.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/custom_button.dart';
import 'package:saghi/widget/custom_loading.dart';
import 'package:saghi/widget/custom_text_form_field.dart';

class ForgetpasswordScreen extends StatelessWidget {
  ForgetpasswordScreen({Key? key}) : super(key: key);

  final email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetCubit(),
      child: BlocConsumer<ForgetCubit, ForgetState>(
        listener: (context, state) {
          if (state is ForgetError) {
            showToast(msg: state.msg, color: Colors.red);
          } else if (state is ForgetSuccess) {
            showToast(msg: "سوف يتم ارسال رابط لتغيير كلمه المرور عبر البريد الالكتروني", color: Colors.green);

            navigateToAndFinish(context, LoginScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfigManger.bodyHeight * .04),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.1),
                          Image.asset(
                            AssetsManger.logo,
                            height: SizeConfigManger.bodyHeight * .25,
                            width: SizeConfigManger.bodyHeight * .25,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                          AppText(
                              text: "تسجيل الدخول",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextFormField(
                              controller: email,
                              type: TextInputType.emailAddress,
                              hintText: "البريد الإلكترونى",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "البريد الإلكترونى مطلوب";
                                }
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.06),
                          state is ForgetLoading
                              ? const CustomLoading()
                              : CustomButton(
                                  press: () async{
                                    if (formKey.currentState!.validate()) {
                                     await ForgetCubit.get(context)
                                          .forgetPassword(email: email.text);
                                    }
                                  },
                                  text: "إرسال",
                                ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.06),
                          AppText(
                              maxLines: 2,
                              align: TextAlign.center,
                              text: "سوف يتم ارسال رابط لتغيير كلمه المرور عبر البريد الالكتروني",
                              color: Colors.red,
                              fontWeight: FontWeight.w300),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
