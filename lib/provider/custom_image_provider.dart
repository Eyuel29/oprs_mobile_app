import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';

class CustomImageProvider extends EasyImageProvider {
  final List<String> photos;

  @override
  final int initialIndex;

  CustomImageProvider({ required this.photos, this.initialIndex = 0 });

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return CachedNetworkImageProvider(photos[index]);
  }

  @override
  Widget progressIndicatorWidgetBuilder(BuildContext context, int index, {double? value}) {
    return CircularProgressIndicator(
      value: value,
      strokeWidth: 3,
      color:MyColors.mainThemeLightColor,
    );
  }

  @override
  Widget errorWidgetBuilder(BuildContext context, int index, Object error, StackTrace? stackTrace) {
    return const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color:MyColors.mainThemeLightColor),
            Text("  No internet!",
              style: TextStyle(fontSize: 16, color:MyColors.mainThemeLightColor),
            )
          ],
        ),
      );
  }

  @override
  int get imageCount => photos.length;
}