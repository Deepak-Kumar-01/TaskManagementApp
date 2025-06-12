import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../../utils/pref/pref_manager.dart';

class LogoutSession extends StatelessWidget {
  const LogoutSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout,color: Colors.white,),
        label: Text("Logout",style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          // Show confirmation dialog before logout
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Confirm Logout"),
              content: Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // cancel
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: ()async {
                    Navigator.pop(context); // close dialog
                    await PrefManager.db.init();
                    PrefManager.db.setIsLoggedIn(false);
                    await FirebaseAuth.instance.signOut();
                    Phoenix.rebirth(context);
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
