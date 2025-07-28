import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/add_photo/add_photo_controller.dart';
import 'package:flutter/material.dart' hide View;
import 'package:shartflix/widgets/shartflix_text_button.dart';

class AddPhotoView extends View {
  const AddPhotoView({super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _AddPhotoViewState(
      AddPhotoController(
        DataUserRepository(),
      ),
    );
  }
}

class _AddPhotoViewState extends ViewState<AddPhotoView, AddPhotoController> {
  _AddPhotoViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: ControlledWidgetBuilder<AddPhotoController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(top: padding.top + 20, bottom: 25, left: 39, right: 39),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: kWhite.withOpacity(0.2), width: 1),
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/arrow_left.svg',
                              height: 20,
                              width: 20,
                              color: kWhite,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Text(
                          'profile_details'.tr(),
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          height: 44,
                          width: 44,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Text(
                      'add_a_photo'.tr(),
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'add_a_photo_description'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 47),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        height: 164,
                        width: 169,
                        decoration: BoxDecoration(
                          color: kWhite.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(31),
                          border: Border.all(color: kWhite.withOpacity(0.2), width: 1.5),
                        ),
                        child: controller.selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(31),
                                child: Image.file(
                                  controller.selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: SvgPicture.asset(
                                  'assets/icons/plus.svg',
                                  height: 26,
                                  width: 26,
                                  color: kWhite.withOpacity(0.5),
                                ),
                              ),
                      ),
                    ),
                    Spacer(),
                    if (controller.selectedImage != null)
                      TextButton(
                        onPressed: controller.removeImage,
                        child: const Text(
                          'Remove Photo',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                          ),
                        ),
                      ),
                    if (controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          controller.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ShartflixTextButton(
                      text: 'continue'.tr(),
                      onPressed: () {
                        if (!controller.isUploading) {
                          controller.uploadPhoto(context);
                        }
                      },
                      isLoading: controller.isUploading,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
