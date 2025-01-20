import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/constants/colors_resource.dart';
import '../../helper/constants/dimensions_resource.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loader;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loader = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(double.infinity, Dimensions.D_55.h),
        ),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_5));
          },
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: Dimensions.FONT_SIZE_15.sp,
            color: ColorResources.PRIMARY_COLOR,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => ColorResources.PRIMARY_COLOR,
        ),
        foregroundColor:
            MaterialStateProperty.all<Color>(ColorResources.WHITE_COLOR),
      ),
      child: loader
          ? SizedBox(
              width: Dimensions.D_25.w,
              height: Dimensions.D_25.h,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorResources.WHITE_COLOR),
              ),
            )
          : Text(text),
    );
  }
}
