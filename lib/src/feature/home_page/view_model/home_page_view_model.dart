import 'package:flutter/cupertino.dart';
import 'package:todoapp/src/feature/home_page/model/todo_model.dart';
import 'package:todoapp/src/service/enum.dart';
import 'package:todoapp/src/service/service.dart';
import 'package:todoapp/utils/enum/page_state_enums.dart';

class HomePageViewModel extends ChangeNotifier {
  List<ToDoModel> todos = [];
  PageState state = PageState.loading;

  late TextEditingController todoTextController;

  HomePageViewModel() {
    _init();
  }

  void _init() async {
    try {
      todos = [];
      todoTextController = TextEditingController();
      state = PageState.loading;
      ApiBase.instance =
          ApiBase(headers: {}, timeoutDuration: const Duration(seconds: 5));

      await getListToDo();
      state = PageState.loaded;
    } catch (e) {
      state = PageState.error;
    }
    notifyListeners();
  }

  Future sendToDo() async {
    try {
      var response = await ApiBase.instance.callApi(
        path: '/altodo_tasksv2',
        httpMethod: HttpMethod.post,
        params: ToDoModel(
          todoTitle: todoTextController.text,
        ).toJson(),
      );
      todoTextController.clear();
      todos.add(ToDoModel.fromJson(response!));
      notifyListeners();
    } catch (e, stk) {
      debugPrintStack(stackTrace: stk);
      print(e);
    }
  }

  Future getToDo(String sId) async {
    try {
      var reponse = await ApiBase.instance.callApi(
        path: '/altodo_tasksv2/$sId',
        httpMethod: HttpMethod.get,
      );

      todos.add(ToDoModel.fromJson(reponse!));
      notifyListeners();
    } catch (e) {
      todos = [];
      rethrow;
    }
  }

  Future getListToDo() async {
    try {
      var reponse = await ApiBase.instance.callApi(
        path: '/altodo_tasksv2',
        httpMethod: HttpMethod.get,
      );

      todos = [];
      if (reponse!['result'] != null && reponse['result'] is List) {
        for (var item in reponse['result']) {
          todos.add(ToDoModel.fromJson(item));
        }
      }
      notifyListeners();
    } catch (e) {
      todos = [];
      rethrow;
    }
  }

  Future<void> updateToDoCheckbox(String? sId, bool? value) async {
    try {
      var reponse = await ApiBase.instance.callApi(
        path: '/altodo_tasksv2/$sId',
        httpMethod: HttpMethod.put,
        fields: {'isDone': value.toString()},
      );

      var index = todos.indexWhere((element) => element.sId == sId);

      todos[index].isDone = value;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> terminateToDo(String sId) async {
    try {
      var reponse = await ApiBase.instance.callApi(
        path: '/altodo_tasksv2/$sId',
        httpMethod: HttpMethod.delete,
      );
      todos.removeWhere((element) => element.sId == sId);
      notifyListeners();
    } catch (e, stk) {
      debugPrintStack(stackTrace: stk);
      print(e);
    }
  }
}
