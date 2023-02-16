import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/screens/auth/register/cubit/register_cubit.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/custom_button.dart';
import 'package:saghi/widget/custom_text_form_field.dart';

import '../../../widget/custom_loading.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is SuccessRegister) {
            Navigator.pop(context);
            showToast(
              msg: "Account created successfully",
              color: Colors.green,
            );
          } else if (state is ErrorRegister) {
            showToast(
              msg: state.error,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
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
                              text: "Create  an account",
                              color: ColorsManger.darkPrimary,
                              fontWeight: FontWeight.bold),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextFormField(
                              controller: firstName,
                              type: TextInputType.text,
                              hintText: "First name",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "First name is required";
                                }
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextFormField(
                              controller: lastName,
                              type: TextInputType.text,
                              hintText: "Last name",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "Last name is required";
                                }
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextFormField(
                              controller: email,
                              type: TextInputType.emailAddress,
                              hintText: "Email",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "Email address is required";
                                }
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: CustomTextFormField(
                              controller: password,
                              type: TextInputType.visiblePassword,
                              isPassword: true,
                              hintText: "Password",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                }
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * 0.06),
                          state is LoadingRegister
                              ? const CustomLoading()
                              : CustomButton(
                                  press: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.registerNewUser(
                                          email: email.text,
                                          password: password.text,
                                          firstName: firstName.text,
                                          lastName: lastName.text);
                                    }
                                  },
                                  text: "Create",
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
      ),
    );
  }
}
