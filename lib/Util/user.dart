class UserData {
  static final UserData _instance = UserData._internal();

  String id;

  factory UserData() {
    return _instance;
  }

  UserData._internal() {
    id = "";
  }
}