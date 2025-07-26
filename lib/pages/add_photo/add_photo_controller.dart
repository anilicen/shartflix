import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPhotoController extends Controller {
  AddPhotoController(UserRepository userRepository) : _userRepository = userRepository;
  final UserRepository _userRepository;

  File? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  String? errorMessage;
  bool isUploading = false;

  @override
  void onInitState() {
    super.onInitState();
  }

  void pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        refreshUI(); // Notify UI to rebuild
      }
    } catch (e) {
      // Handle error - you might want to show a snackbar or dialog
      print('Error picking image: $e');
    }
  }

  void removeImage() {
    selectedImage = null;
    refreshUI();
  }

  Future<void> uploadPhoto(BuildContext context) async {
    if (selectedImage == null) {
      errorMessage = 'No image selected';
      refreshUI();
      return;
    }

    // Validate file exists and size
    if (!await selectedImage!.exists()) {
      errorMessage = 'Selected image file not found';
      refreshUI();
      return;
    }

    final fileSize = await selectedImage!.length();
    const maxFileSize = 10 * 1024 * 1024; // 10MB limit
    if (fileSize > maxFileSize) {
      errorMessage = 'Image file is too large (max 10MB)';
      refreshUI();
      return;
    }

    // Clear previous errors and set loading state
    errorMessage = null;
    isUploading = true;
    refreshUI();

    try {
      await _userRepository.addPhoto(selectedImage!);
      // Handle successful upload
      print('Photo uploaded successfully');
      isUploading = false;
      refreshUI();

      // You can navigate back or show success message here
      // Navigator.of(context).pop();
    } catch (e) {
      isUploading = false;
      errorMessage = e.toString();
      if (errorMessage!.startsWith('Exception: ')) {
        errorMessage = errorMessage!.substring(11); // Remove "Exception: " prefix
      }
      refreshUI();
      print('Upload failed: $errorMessage');
    }
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
