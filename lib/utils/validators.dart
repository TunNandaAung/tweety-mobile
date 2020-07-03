class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _nameRegExp = RegExp(r'.+');

  // static final RegExp _passwordRegExp = RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  // );
  static final RegExp _phoneRegExp = RegExp(
    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
  );

  static isValidName(String name) {
    return _nameRegExp.hasMatch(name);
  }

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    //return _passwordRegExp.hasMatch(password);
    return true;
  }

  static isValidPhone(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }
}
