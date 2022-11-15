import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/common/widget/LoadingWidget.dart';
import 'package:todo_app/src/login/di/login_provider.dart';
import 'package:todo_app/src/login/ui/model/login_page_state.dart';
import 'package:todo_app/src/login/ui/viewmodel/LoginPageViewModel.dart';
import 'package:todo_app/src/todo/ui/todo_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return MultiProvider(
      providers: loginProviders,
      child: Consumer<LoginPageViewModel>(builder: (context, viewModel, _) {
        switch (viewModel.state) {
          case LoginPageState.loading:
            return const LoadingWidget();
          case LoginPageState.noUser:
            return Scaffold(
              appBar: AppBar(
                title: Text(localization?.appTitle ?? ''),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(localization?.loginPageDescription ?? ''),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: viewModel.nameFieldController,
                      decoration: InputDecoration(
                        labelText: localization?.name ?? '',
                        errorText: viewModel.nameError
                            ? localization?.invalidName
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: viewModel.onAuthorConfirmPressed,
                        child: Text(localization?.enterButtonText ?? ''),
                      ),
                    )
                  ],
                ),
              ),
            );
          case LoginPageState.userAlreadyEntered:
            return const TodoPage();
        }
      }),
    );
  }
}
