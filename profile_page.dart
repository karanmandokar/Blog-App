import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(icon:const Icon(Icons.edit),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>const EditProfilePage()));})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?.email ?? "No Email",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(user?.email ?? ""),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_user),
                title: const Text("User ID"),
                subtitle: Text(user?.uid ?? ""),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Account Created"),
                subtitle: Text(
                  user?.metadata.creationTime
                      .toString() ??
                      "",
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.popUntil(
                  context,
                      (route) => route.isFirst,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}