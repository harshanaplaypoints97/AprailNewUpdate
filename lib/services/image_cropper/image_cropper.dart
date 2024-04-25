import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperService {
  static Future<File> pickMedia({
    bool isGallery,
    bool isProfilePicure,
    Future<File> Function(File file) cropImage,
  }) async {
    try {
      debugPrint("-2");
      final source = isGallery ? ImageSource.gallery : ImageSource.camera;
      debugPrint("-1");
      final pickedFile = await ImagePicker().pickImage(source: source);
      debugPrint("0");
      if (pickedFile == null) return null;
      debugPrint("1");
      if (cropImage == null) {
        debugPrint("2");
        return File(pickedFile.path);
      } else {
        debugPrint("3");
        final file = File(pickedFile.path);
        debugPrint("4");
        return isProfilePicure ? cropImage(file) : cropRectangleImage(file);
      }
    } catch (e) {
      throw "camera image failure $e";
    }
  }

  static Future<File> cropSquareImage(File imahgeFile) async {
    final file = await ImageCropper().cropImage(
        sourcePath: imahgeFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    return File(file.path);
  }

  static Future<File> cropRectangleImage(File imahgeFile) async {
    final file = await ImageCropper().cropImage(
        sourcePath: imahgeFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        aspectRatioPresets: [CropAspectRatioPreset.ratio5x3]);
    return File(file.path);
  }

  static Future<File> cropFreeSizeImage(File imahgeFile) async {
    final file = await ImageCropper().cropImage(sourcePath: imahgeFile.path,
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ]);
    return File(file.path);
  }
}
