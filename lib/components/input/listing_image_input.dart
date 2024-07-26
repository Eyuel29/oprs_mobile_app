import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oprs/constant_values.dart';


class MultiImageInput extends StatefulWidget {

  final void Function(List<XFile> images) onImagesSelected;
  const MultiImageInput({super.key, required this.onImagesSelected});
  @override
  State<MultiImageInput> createState() => _MultiImageInputState();
}

class _MultiImageInputState extends State<MultiImageInput> {
  List<XFile> _images = [];
  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _images = pickedImages;
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.6,
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
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: _images.isEmpty ?
                      const Icon(
                          Icons.camera_alt_rounded,size: 50, color: MyColors.mainThemeDarkColor
                      ) : Image.file(File(_images[0].path)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
        ),

        const SizedBox(height: 10,),
        _images.isEmpty ? Container(
            alignment: Alignment.center,
            child: const Text(
              "No Selected Images",
              textAlign: TextAlign.start
            )
        ) : Container(),
        const SizedBox(height: 10),
        MasonryView(
          listOfItem: List.generate(_images.length, (index) {
            return _buildImage(_images[index]);
          }),
          itemPadding: 5,
          itemRadius: 5,
          numberOfColumn: 2,
          itemBuilder: (item) {
            return item;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImage(XFile image) {
    return Container(
      width: (MediaQuery.of(context).size.width / 3) * 0.9,
      padding: const EdgeInsets.all(10),
      child: Image.file(File(image.path)),
    );
  }
}
