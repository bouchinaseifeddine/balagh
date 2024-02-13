import 'dart:io';

import 'package:balagh/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(
      {super.key, required this.onPickImage, required this.imageUrl});

  final void Function(File pickedImage) onPickImage;
  final String imageUrl;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _pickImage,
          child: widget.imageUrl == ''
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: kLightGrey,
                  foregroundImage: _pickedImageFile != null
                      ? FileImage(_pickedImageFile!)
                      : null,
                  child: _pickedImageFile == null
                      ? const Icon(
                          Icons.camera_alt_rounded,
                          color: kLightBlue,
                        )
                      : null,
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: kLightGrey,
                  foregroundImage: NetworkImage(widget.imageUrl),
                ),
        ),
      ],
    );
  }
}
