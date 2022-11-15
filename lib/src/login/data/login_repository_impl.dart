import 'package:todo_app/src/login/data/local/login_local_data_source.dart';

import '../domain/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginLocalDatasource _localDataSource;

  LoginRepositoryImpl(this._localDataSource);

  @override
  Future<String?> author() => _localDataSource.author();

  @override
  Future<bool> storeAuthor(String author) =>
      _localDataSource.storeAuthor(author);
}
