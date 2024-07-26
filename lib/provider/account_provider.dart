import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oprs/model/user.dart';

class AccountProvider extends ChangeNotifier {
  User user;
  bool pageLoading = false;
  bool signOutWaiting = false;
  String errorMessage = "";
  AccountProvider({required this.user});

  void setUser(User u) {
    user = u;
    notifyListeners();
  }

  Future<void> deleteUserData() async {
    signOutWaiting = true;
    notifyListeners();
    try {
      var storage = const FlutterSecureStorage();
      var userFound = await storage.containsKey(key: "authenticated_user");
      var sessionFound = await storage.containsKey(key: "session_id");
      if (userFound) await storage.delete(key: "authenticated_user");
      if (sessionFound) await storage.delete(key: "session_id");
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      signOutWaiting = false;
      notifyListeners();
    }
  }

}
