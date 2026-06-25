class AppValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is required";
    }

    if (!value.endsWith("@gmail.com")) {
      return "Invalid email";
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password too short";
    }

    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) {
      return "Name is required";
    }

    return null;
  }

  static String? validateMobile(String value) {
    if (value.isEmpty) {
      return "Mobile is required";
    }
    // if (!value.startsWith("09")) {
    //   return "Mobile number should start with 09";
    // }
    if (value.length < 13) {
      return "Mobile number should be only 13 digits";
    }

    return null;
  }
}
