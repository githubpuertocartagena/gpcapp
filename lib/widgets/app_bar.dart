import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username") ?? "Invitado";
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false, // 🔥 Elimina la flecha atrás
      actions: [
        FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final username = snapshot.data ?? "Invitado";

            return Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
                  onSelected: (value) {
                    if (value == "logout") _logout(context);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: "logout",
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text("Cerrar sesión"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
