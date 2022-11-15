import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/src/todo/data/local/todo_local_data_source.dart';

class TodoLocalDatasourceImpl extends TodoLocalDatasource {
  final Future<SharedPreferences> _sharedPreference;

  TodoLocalDatasourceImpl(this._sharedPreference);

  @override
  Future<String?> author() =>
      _sharedPreference.then((value) => value.getString("author"));
}
