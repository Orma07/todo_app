import 'package:flutter/material.dart';
import 'package:todo_app/src/login/domain/login_repository.dart';

import '../model/login_page_state.dart';

class LoginPageViewModel extends ChangeNotifier {
  late LoginRepository _repository;
  LoginPageState state = LoginPageState.loading;

  var nameFieldController = TextEditingController();
  var nameError = false;

  LoginPageViewModel inject(LoginRepository repository) {
    _repository = repository;
    _onInit();
    return this;
  }

  _onInit() async {
    final author = await _repository.author();
    if (author?.isNotEmpty == true) {
      state = LoginPageState.userAlreadyEntered;
    } else {
      state = LoginPageState.noUser;
    }
    notifyListeners();
  }

  void onAuthorConfirmPressed() async {
    if (nameFieldController.text.isNotEmpty) {
      _repository.storeAuthor(nameFieldController.text);
      state = LoginPageState.userAlreadyEntered;
    } else {
      nameError = true;
    }
    notifyListeners();
  }
}
