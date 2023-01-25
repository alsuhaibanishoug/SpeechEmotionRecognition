import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:saghi/models/user_model.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void registerNewUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    emit(LoadingRegister());

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName);

      FirebaseFirestore.instance
          .collection(ConstantsManger.users)
          .doc(userModel.id)
          .set(userModel.toJson());
      emit(SuccessRegister());
    } catch (e) {
      emit(ErrorRegister(e.toString()));
    }
  }
}
