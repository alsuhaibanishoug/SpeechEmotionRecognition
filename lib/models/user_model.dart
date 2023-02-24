import 'package:equatable/equatable.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String image;

  const UserModel(
      {required this.id,
      required this.email,
      required this.password,
      this.image = ConstantsManger.defaultValue,
      required this.firstName,
      required this.lastName});

  factory UserModel.fromJson({required Map<String, dynamic> map}) => UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      image: map['image'],
      firstName: map['firstName'],
      lastName: map['lastName']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "password": password,
      "firstName": firstName,
      "image": image,
      "lastName": lastName,
    };
  }

  @override
  List<Object?> get props => [id, email, password, firstName, lastName, image];
}
