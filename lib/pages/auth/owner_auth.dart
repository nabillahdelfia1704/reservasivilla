class OwnerAuth {
  static bool isLoggedIn = false;
  static Map<String, dynamic>? currentOwner;

  static void login(Map<String, dynamic> ownerData) {
    isLoggedIn = true;
    currentOwner = ownerData;
  }

  static void logout() {
    isLoggedIn = false;
    currentOwner = null;
  }
}
