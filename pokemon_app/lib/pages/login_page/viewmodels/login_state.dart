enum LoginStatus{
  loading,
  success,
  errorUserPass,
  internalServerError
}

class LoginState{
  LoginStatus status;
  LoginState(this.status);

  LoginState copyWith({required LoginStatus status}){
    return LoginState(status);
  }
}