import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/src/common/network/provides_dio.dart';
import 'package:todo_app/src/todo/data/local/todo_local_data_source.dart';
import 'package:todo_app/src/todo/data/local/todo_local_data_source_impl.dart';
import 'package:todo_app/src/todo/data/remote/todo_remote_data_source.dart';
import 'package:todo_app/src/todo/data/remote/todo_remote_data_source_impl.dart';
import 'package:todo_app/src/todo/data/todo_repository_impl.dart';
import 'package:todo_app/src/todo/ui/viewmodel/todo_view_model.dart';

import '../domain/todo_repository.dart';

List<SingleChildWidget> todoProviders = [..._dependentServices];

List<SingleChildWidget> _dependentServices = [
  Provider(create: (context) => providesDio("https://9gyqk52uc0.execute-api.eu-west-2.amazonaws.com/prod/")),
  Provider(create: (context) => SharedPreferences.getInstance()),
  ProxyProvider<Future<SharedPreferences>, TodoLocalDatasource>(
      update: (context, futureSharedPreference, _) =>
          TodoLocalDatasourceImpl(futureSharedPreference)),
  ProxyProvider<Dio, TodoRemoteDataSource>(
      update: (context, client, _) => TodoRemoteDataSourceImpl(client)),
  ProxyProvider2<TodoRemoteDataSource, TodoLocalDatasource, TodoRepository>(
      update: (context, remoteDtaSource, localDataSource, _) =>
          TodoRepositoryImpl(localDataSource, remoteDtaSource)),
  ChangeNotifierProxyProvider<TodoRepository, TodoViewModel>(
      create: (context) => TodoViewModel(),
      update: (context, repository, viewModel) =>
          viewModel?.inject(repository, AppLocalizations.of(context)!) ??
          TodoViewModel()),
];
