import 'package:firebase_auth/firebase_auth.dart';

//Enforces a singleton pattern-only one instance of App exists.
class App {
  //Private Constructor
  App._();
  //Singleton Instance-creates a single instance of the App class and stores it in "instance"
  //Now, "App.instance" can be used anywhere in the app to access its properties and methods.
  static final App instance = App._();

  String userId = "";
  String token = "";
  bool isTest = false;

  //Initialize the App
  Future<void> init({bool refreshToken = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      //Gets the authentication token (JWT)
      token = (await user.getIdToken(refreshToken))!;
    }
  }
}
