class AuthService {
  static bool isLoggedIn = false;
  static Map<String, dynamic>? currentUser;

  static void login(Map<String, dynamic> user) {
    isLoggedIn = true;
    currentUser = user;
  }

  static void logout() {
    isLoggedIn = false;
    currentUser = null;
  }
}
