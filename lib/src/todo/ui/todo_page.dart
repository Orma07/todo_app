import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/common/widget/LoadingWidget.dart';
import 'package:todo_app/src/todo/di/todo_provider.dart';
import 'package:todo_app/src/todo/ui/model/todo_page_state.dart';
import 'package:todo_app/src/todo/ui/viewmodel/todo_view_model.dart';
import 'package:todo_app/src/todo/ui/widget/add_todo_widget.dart';
import 'package:todo_app/src/todo/ui/widget/edit_todo_widget.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return MultiProvider(
        providers: todoProviders,
        child: Consumer<TodoViewModel>(builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(localization.appTitle),
            ),
            floatingActionButton: Builder(
              builder: (BuildContext scaffoldContext) {
                return FloatingActionButton(
                  onPressed: () {
                    viewModel.onAddTodoPressed();
                    addPressed(scaffoldContext);
                  },
                  child: const Icon(Icons.add),
                );
              },
            ),
            body: Builder(
              builder: (BuildContext scaffoldContext) {
                if (viewModel.state == TodoPageState.loading) {
                  return const LoadingWidget();
                } else {
                  return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: viewModel.todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = viewModel.todos[index];
                        return GestureDetector(
                          onTap: () {
                            viewModel.onTodoPressed(item);
                            todoPressed(context);
                          },
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: item.done,
                                  onChanged: (bool? value) {},
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    if (item.description.isNotEmpty)
                                      Row(
                                        children: [
                                          Text(
                                            localization.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(item.description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ],
                                      ),
                                    if (item.dueDate != null)
                                      Row(
                                        children: [
                                          Text(
                                            localization.dueDate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(
                                              viewModel
                                                  .formatDate(item.dueDate),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ],
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ));
                }
              },
            ),
          );
        }));
  }

  void addPressed(BuildContext context) {
    showBottomSheet(
        context: context,
        elevation: 8,
        builder: (context) {
          return AddTodoWidget();
        });
  }

  void todoPressed(BuildContext context) {
    showBottomSheet(
        context: context,
        elevation: 8,
        builder: (context) {
          return EditTodoWidget();
        });
  }
}
