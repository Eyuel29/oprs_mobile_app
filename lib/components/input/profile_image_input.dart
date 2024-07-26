import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oprs/constant_values.dart';

class ProfileImageInput extends StatefulWidget {
  final List<XFile> currentImages;
  final Function(List<XFile> images) onImagesSelected;
  
  const ProfileImageInput({
    super.key,
    required this.onImagesSelected,
    this.currentImages = const []
  });

  @override
  State<ProfileImageInput> createState() => _ProfileImageInputState();
}

class _ProfileImageInputState extends State<ProfileImageInput> {
  List<XFile> _images = [];

  @override
  void initState() {
    _images = widget.currentImages;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CupertinoButton(
                color: MyColors.mainThemeDarkColor.withOpacity(0.1),
                onPressed: _pickImages,
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: _images.isEmpty ?
                    const Icon(
                      Icons.person,
                      size: 50,
                      color: MyColors.mainThemeDarkColor
                    ) : Image.file(
                      File(
                        _images[0].path
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Photo",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor
                ),
              ),
            ],
          )
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _images = pickedImages;
      });
      widget.onImagesSelected(_images);
    }
  }
}
