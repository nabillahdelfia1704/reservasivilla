class OwnerAuth {
  static bool isLoggedIn = false;
  static Map<String, dynamic>? currentOwner;

  static void login(Map<String, String> ownerData) {
    isLoggedIn = true;
    currentOwner = Map<String, dynamic>.from(ownerData); // ← convert ke dynamic
  }

  static void logout() {
    isLoggedIn = false;
    currentOwner = null;
  }
}
