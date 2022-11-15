import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/todo/ui/viewmodel/todo_view_model.dart';

class EditTodoWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  EditTodoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, _) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                Column(
                  children: <Widget>[
                    Text(
                      localization.editTodoData,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: localization.titleForm,
                        ),
                        controller: viewModel.editTodoState.titleController,
                        validator: viewModel.editTodoState.textValidator,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: localization.descriptionForm,
                      ),
                      controller: viewModel.editTodoState.descriptionController,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: localization.dateForm,
                      ),
                      controller: viewModel.editTodoState.dateController,
                      onTap: () async {
                        viewModel.onEditTodoDateChanged(await showDatePicker(
                            context: context,
                            firstDate: viewModel.editTodoState.dueDate ??
                                DateTime.now(),
                            initialDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365))));
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Switch(
                              value: viewModel.editTodoState.isDone,
                              onChanged: (value) => viewModel.onIsDoneChanged(),
                            ),
                            const SizedBox(width: 16),
                            Text(localization.isDone)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                viewModel.updateTodo();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(localization.save),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                viewModel.deleteTodo();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(localization.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
