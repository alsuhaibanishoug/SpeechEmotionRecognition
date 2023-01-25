import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/main_layout/main_layout.dart';
import 'package:saghi/screens/auth/forget_password/forget_password.dart';
import 'package:saghi/screens/auth/login/cubit/login_cubit.dart';
import 'package:saghi/screens/auth/register/register_screen.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/custom_button.dart';
import 'package:saghi/widget/custom_loading.dart';
import 'package:saghi/widget/custom_text_form_field.dart';

import '../../../layout_un_registerd/layout_un_registerd.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
       if(state is LoginError){
         showToast(msg: state.errorMsg, color: Colors.red);
       }else if(state is LoginSuccess){
         navigateToAndFinish(context, MainLayout());
       }
      },
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
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
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.05),
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
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CustomTextFormField(
                            controller: password,
                            type: TextInputType.visiblePassword,
                            isPassword: true,
                            hintText: "كلمة المرور",
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "كلمة المرور مطلوب";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.06),
                        state is LoginLoading ? const CustomLoading():CustomButton(
                          press: () {
                            if(formKey.currentState!.validate()){
                              cubit.signIn(email: email.text, password: password.text);
                            }
                          },
                          text: "تسجيل",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        GestureDetector(
                          onTap: () =>
                              navigateTo(context, ForgetpasswordScreen()),
                          child: AppText(
                              text: "هل نسيت كلمة المرور ؟",
                              color: Colors.black,
                              textDecoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        Row(
                          children: [
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                            )),
                            GestureDetector(
                              onTap: () =>
                                  navigateTo(context, RegisterScreen()),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenHeight(
                                        10)),
                                child: AppText(
                                    text: "إنشاء حساب",
                                    color: Colors.black,
                                    textDecoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                            )),

                          ],
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.15),
                        GestureDetector(
                          onTap: ()=>navigateTo(context, const LayoutUnRegisterd()),
                          child: AppText(
                              text: "الدخول كضيف",
                              color: Colors.black,
                              textDecoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
