import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helper/constants/colors_resource.dart';
import '../../helper/constants/dimensions_resource.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorResources.PRIMARY_COLOR,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ColorResources.WHITE_COLOR),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: ColorResources.WHITE_COLOR,
              fontSize: Dimensions.FONT_SIZE_DEFAULT.w,
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
