import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/businessLogic/bloc/galleryScreenBloc/gallery_screen_bloc.dart';
import 'package:cardealershipapp/helper/constants/colors_resource.dart';
import 'package:cardealershipapp/helper/constants/dimensions_resource.dart';
import 'package:cardealershipapp/helper/constants/screen_percentage.dart';
import 'package:cardealershipapp/helper/constants/string_resources.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GalleryBloc>().add(FetchImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringResources.GALLERY_TITLE,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: ColorResources.WHITE_COLOR,
                fontSize: Dimensions.FONT_SIZE_LARGE.sp,
              ),
        ),
        backgroundColor: ColorResources.PRIMARY_COLOR,
        centerTitle: true,
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.hasError) {
            return const Center(child: Text('An error occurred!'));
          }
          if (state.imageUrls.isEmpty) {
            return const Center(child: Text('No images found.'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: ScreenPercentage.SCREEN_SIZE_1.sw,
              mainAxisSpacing: ScreenPercentage.SCREEN_SIZE_1.sw,
            ),
            itemCount: state.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    _showFullScreenImage(context, state.imageUrls[index]),
                child: Container(
                  color: ColorResources.PRIMARY_COLOR,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          state.imageUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              // Image has loaded
                              return child;
                            } else {
                              return Container(
                                color: ColorResources.PRIMARY_COLOR,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorResources.WHITE_COLOR),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorResources.BLACK_COLOR,
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
