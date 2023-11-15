import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _newMessageController = TextEditingController();

  @override
  void dispose() {
    _newMessageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _newMessageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData.data()!["username"],
      "userImage": userData.data()!["image_url"]
    });

    _newMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 1,
          bottom: 14,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newMessageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration:
                    const InputDecoration(labelText: "Send a message..."),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}
