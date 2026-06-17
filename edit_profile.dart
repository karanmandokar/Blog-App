import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final bioController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      nameController.text = data['name'] ?? '';
      mobileController.text = data['mobile'] ?? '';
      cityController.text = data['city'] ?? '';
      bioController.text = data['bio'] ?? '';
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'name': nameController.text.trim(),
      'mobile': mobileController.text.trim(),
      'city': cityController.text.trim(),
      'bio': bioController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    cityController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 45,
                  child: Icon(
                    Icons.person,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.isEmpty
                      ? "Enter Name"
                      : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: mobileController,
                  keyboardType:
                  TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.isEmpty
                      ? "Enter Mobile Number"
                      : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.isEmpty
                      ? "Enter City"
                      : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: updateProfile,
                    child: const Text(
                      "Update Profile",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}