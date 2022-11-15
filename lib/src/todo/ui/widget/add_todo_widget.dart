import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/todo/ui/viewmodel/todo_view_model.dart';

class AddTodoWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddTodoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Consumer<TodoViewModel>(builder: (context, viewModel, _) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              Column(
                children: <Widget>[
                  Text(
                    localization.addTodoData,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: localization.titleForm,
                      ),
                      controller: viewModel.addTodoState.titleController,
                      validator: viewModel.addTodoState.textValidator,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: localization.descriptionForm,
                    ),
                    controller: viewModel.addTodoState.descriptionController,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: localization.dateForm,
                    ),
                    controller: viewModel.addTodoState.dateController,
                    onTap: () async {
                      viewModel.onAddTodoDateChanged(await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365))));
                    },
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.saveNewTodo();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(localization.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
