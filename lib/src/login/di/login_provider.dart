import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/src/login/data/local/login_local_data_source.dart';
import 'package:todo_app/src/login/data/local/login_local_data_source_impl.dart';
import 'package:todo_app/src/login/data/login_repository_impl.dart';
import 'package:todo_app/src/login/domain/login_repository.dart';
import 'package:todo_app/src/login/ui/viewmodel/LoginPageViewModel.dart';

List<SingleChildWidget> loginProviders = [..._dependentServices];

List<SingleChildWidget> _dependentServices = [
  Provider(create: (BuildContext context) => SharedPreferences.getInstance()),
  ProxyProvider<Future<SharedPreferences>, LoginLocalDatasource>(
      update: (context, futureSharedPreferences, _) =>
          LoginLocalDataSourceImpl(futureSharedPreferences)),
  ProxyProvider<LoginLocalDatasource, LoginRepository>(
    update: (context, localDataSource, _) =>
        LoginRepositoryImpl(localDataSource),
  ),
  ChangeNotifierProxyProvider<LoginRepository, LoginPageViewModel>(
    create: (context) => LoginPageViewModel(),
    update: (context, repository, viewModel) =>
        viewModel?.inject(repository) ?? LoginPageViewModel(),
  )
];
