import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBlogPage extends StatefulWidget {
  final String docId;
  final String title;
  final String content;

  const EditBlogPage({
    super.key,
    required this.docId,
    required this.title,
    required this.content,
  });

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.title);

    contentController =
        TextEditingController(text: widget.content);
  }

  Future<void> updateBlog() async {
    await FirebaseFirestore.instance
        .collection('blogs')
        .doc(widget.docId)
        .update({
      'title': titleController.text.trim(),
      'content': contentController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Blog Updated Successfully'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateBlog,
              child: const Text("Update Blog"),
            ),
          ],
        ),
      ),
    );
  }
}