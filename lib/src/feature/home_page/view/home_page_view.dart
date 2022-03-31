import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/src/feature/home_page/view_model/home_page_view_model.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlToDo'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => HomePageViewModel(),
        child: Consumer<HomePageViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: viewModel.todoTextController,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: viewModel.sendToDo,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: viewModel.todos.length,
                      separatorBuilder: (_, __) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => viewModel.terminateToDo(
                                      viewModel.todos[index].sId!),
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                )
                              ],
                            ),
                            child: ListTile(
                              onTap: () => viewModel.updateToDoCheckbox(
                                  viewModel.todos[index].sId,
                                  !(viewModel.todos[index].isDone ?? false)),
                              tileColor:
                                  (viewModel.todos[index].isDone ?? false)
                                      ? Colors.blue
                                      : null,
                              title:
                                  Text(viewModel.todos[index].todoTitle ?? ''),
                              trailing: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Colors.blue,
                                  onChanged: (value) =>
                                      viewModel.updateToDoCheckbox(
                                          viewModel.todos[index].sId, value),
                                  value: viewModel.todos[index].isDone),
                            ),
                          ),
                        );
                      }),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
