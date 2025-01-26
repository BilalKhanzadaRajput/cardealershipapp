import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/constants/colors_resource.dart';
import '../../helper/constants/dimensions_resource.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? validator;
  final bool obscureText;
  final String prefixIconSvgPath;
  final bool showSuffixIcon;
  final VoidCallback? onVisibilityTap;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final int? maxLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.onChanged,
    this.validator,
    required this.prefixIconSvgPath,
    this.showSuffixIcon = false,
    this.obscureText = false,
    this.onVisibilityTap,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.height,
    this.width,
    this.controller,
    this.maxLines,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? Dimensions.D_80.h, // Use default height if not provided
      width: width ?? double.infinity, // Use default width if not provided
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorResources.GREY_COLOR.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: obscureText ? 1 : maxLines,
        style: TextStyle(color: ColorResources.BLACK_COLOR),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT.sp),
          filled: true,
          prefixIcon: Padding(

            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT.w),

            child: SvgPicture.asset(prefixIconSvgPath),
          ),
          suffixIcon: showSuffixIcon
              ? GestureDetector(
                  onTap: onVisibilityTap,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT.w),
                    child: obscureText
                        ? Icon(Icons.visibility_off,
                            color: ColorResources.GREY_COLOR)
                        : Icon(Icons.visibility,
                            color: ColorResources.GREY_COLOR),
                  ),
                )
              : null,
          fillColor: ColorResources.WHITE_COLOR,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          ),
          // Ensure error message doesn’t affect height
          errorStyle: TextStyle(
            fontSize: Dimensions.FONT_SIZE_SMALL.sp,
            height: 1.1, // Adjust height to control spacing below input field
          ),
          errorMaxLines: 2, // Set a limit for error message lines
        ),


        obscureText: obscureText,
        onChanged: onChanged,
        validator: (value) {
          return validator?.call(value ?? '');
        },
        focusNode: focusNode,
        keyboardType: keyboardType,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
      ),
    );
  }
}