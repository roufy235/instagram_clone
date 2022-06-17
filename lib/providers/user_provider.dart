import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;// make sure its private
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _userModel = user;
    notifyListeners();
  }

}
