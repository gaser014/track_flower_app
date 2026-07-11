import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:track_flowers_app/core/widgets/custom_cached_image.dart';

class EditProfilePhotoWidget extends StatefulWidget {
  final String? networkPhotoUrl;
  final String? localPhotoPath;
  final Function(File) onPhotoSelected;

  const EditProfilePhotoWidget({
    super.key,
    this.networkPhotoUrl,
    this.localPhotoPath,
    required this.onPhotoSelected,
  });

  @override
  State<EditProfilePhotoWidget> createState() => _EditProfilePhotoWidgetState();
}

class _EditProfilePhotoWidgetState extends State<EditProfilePhotoWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onPhotoSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grayEA,
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.localPhotoPath != null
                ? Image.file(
                    File(widget.localPhotoPath!),
                    fit: BoxFit.cover,
                  )
                : widget.networkPhotoUrl != null &&
                        widget.networkPhotoUrl!.isNotEmpty
                    ? CustomCachedImage(
                        imagePath: widget.networkPhotoUrl!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.gray7D,
                      ),
          ),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grayEA, width: 1),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: AppColors.pink7C,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
