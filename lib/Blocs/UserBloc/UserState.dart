enum LoginStatus {
  NON_LOGIN,
  LOGGING,
  LOGIN_SUCCESS,
  LOGIN_ERROR,
}

class LoginState {
  final LoginStatus status;
  final String message;

  LoginState({this.status, this.message});
}
