import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/src/login/data/local/login_local_data_source.dart';

class LoginLocalDataSourceImpl extends LoginLocalDatasource {
  final Future<SharedPreferences> _sharedPreference;

  LoginLocalDataSourceImpl(this._sharedPreference);

  @override
  Future<String?> author() =>
      _sharedPreference.then((value) => value.getString("author"));

  @override
  Future<bool> storeAuthor(String author) =>
      _sharedPreference.then((value) => value.setString("author", author));
}
