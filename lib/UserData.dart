class UserData {
  static final UserData _userData = UserData._internal();
  String userName = '';
  String password = '';

  UserData._internal();

  factory UserData() {
    return _userData;
  }

  String getUserName() {
    return userName;
  }

  String getPassword() {
    return password;
  }

  
}
