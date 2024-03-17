import 'dart:io';
import 'package:balagh/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takaPicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = IconButton(
      onPressed: _takaPicture,
      icon: const Icon(
        Icons.camera_alt,
        color: kMidtBlue,
      ),
    );
    if (_selectedImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: content,
    );
  }
}
