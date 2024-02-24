import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/model/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// ignore: camel_case_types
class NewComment extends StatefulWidget {
  const NewComment({super.key, required this.report});

  final Report report;
  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  var _typedComment = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  void _submitMessage() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    if (_typedComment.trim().isEmpty) {
      return;
    }

    print(_typedComment);
    FocusScope.of(context).unfocus();
    _commentController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      FirebaseFirestore.instance.collection('comments').add({
        'text': _typedComment,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'userName': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
        'reportId': widget.report.reportId,
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _commentController,
        style: const TextStyle(color: kWhite),
        decoration: InputDecoration(
          fillColor: kMidtBlue,
          prefixIconColor: kWhite,
          suffixIconColor: kWhite,
          hintStyle: const TextStyle(color: kWhite),
          prefixIcon: const Icon(
            Ionicons.chatbubble,
            size: 30,
          ),
          hintText: 'Type something ...',
          suffixIcon: GestureDetector(
            onTap: () {
              _submitMessage();
            },
            child: const Icon(
              Ionicons.arrow_up_circle,
              size: 36,
            ),
          ),
        ),
        onSaved: (value) {
          _typedComment = value!;
        },
      ),
    );
  }
}
