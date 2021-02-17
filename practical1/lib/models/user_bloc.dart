import 'dart:async';
import 'user.dart';
import 'package:practical1/networking.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practical1/models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());

  List<User> allUsers = [];
  int from = 0;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetData) {
      if (allUsers.length == 0) {
        yield UserLoading();
      }
      var allData = await getData(from);
      for (var x in allData) {
        allUsers.add(User(loginName: x['login'], avatarUrl: x['avatar_url']));
        from++;
      }

      yield UserSuccess(users: allUsers);
    }

    if (event is ChangeBookmark) {
      allUsers[event.index].isChecked = event.newValue;
      yield UserSuccess(users: allUsers);
    }
  }
}

getData(int from) async {
  NetworkHelper networkHelper =
      NetworkHelper('https://api.github.com/users?per_page=12&since=$from');

  var allData = await networkHelper.getData();
  return allData;
}
