import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/helper/extension/strings_extensions.dart';
import 'package:cardealershipapp/presentation/routes/routes_name.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../businessLogic/bloc/signUpScreenBloc/sign_up_screen_bloc.dart';
import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';
import '../../../helper/constants/image_resources.dart';
import '../../../helper/constants/screen_percentage.dart';
import '../../../helper/constants/string_resources.dart';
import '../../customWidgets/custom_button.dart';
import '../../customWidgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.BACKGROUND_COLOR,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              // Image Container - Appears first
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources
                      .PRIMARY_COLOR, // Define color inside BoxDecoration
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),
                    bottomRight:
                        Radius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenPercentage.SCREEN_SIZE_7.sw),
                    child: Image(
                      image: const AssetImage(ImageResources.APP_LOGO_IMAGE),
                      width: Dimensions.D_200.w,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<SignUpScreenBloc, SignUpScreenState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                StringResources.SIGNUP_HEADING,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_LARGE.sp),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  hintText: StringResources.FULL_NAME_HINT,
                                  onChanged: (value) {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(SignUpFullNameChanged(value));
                                  },
                                  validator: (value) => value.isEmpty
                                      ? "Enter your full name"
                                      : null,
                                  prefixIconSvgPath: ImageResources.USER_ICON,
                                ),
                                // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                // CustomTextFormField(
                                //   hintText: StringResources.SHOWROOM_NAME_HINT,
                                //   onChanged: (value) {
                                //     context
                                //         .read<SignUpScreenBloc>()
                                //         .add(SignUpFatherNameChanged(value));
                                //   },
                                //   validator: (value) => value.isEmpty
                                //       ? "Enter your showroom name"
                                //       : null,
                                //   prefixIconSvgPath: ImageResources.USER_ICON,
                                // ),

                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                CustomTextFormField(
                                  hintText: StringResources.EMAIL_HINT,
                                  onChanged: (value) {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(SignUpEmailChanged(value));
                                  },
                                  validator: (value) =>
                                      value.validatePassword(value),
                                  prefixIconSvgPath: ImageResources.EMAIL_ICON,
                                ),
                                // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),

                                // // // For CNIC (13 digits)
                                // // CustomTextFormField(
                                // //   hintText: StringResources.CNIC_HINT,
                                // //   onChanged: (value) {
                                // //     context
                                // //         .read<SignUpScreenBloc>()
                                // //         .add(SignUpCnicChanged(value));
                                // //   },
                                // //   validator: (value) => value.validateNIC(value),
                                // //   prefixIconSvgPath: ImageResources.ID_ICON,
                                // //   keyboardType: TextInputType.number,
                                // //   inputFormatters: [
                                // //     FilteringTextInputFormatter.digitsOnly,
                                // //     // Only digits allowed
                                // //     LengthLimitingTextInputFormatter(13),
                                // //     // Limit to 13 digits
                                // //   ],
                                // // ),

                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),

                                CustomTextFormField(
                                  hintText: StringResources.PHONE_HINT,
                                  onChanged: (value) {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(SignUpPhoneChanged(value));
                                  },
                                  validator: (value) =>
                                      value.validatePhoneNumber(value),
                                  prefixIconSvgPath: ImageResources.PHONE_ICON,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    // Only digits allowed
                                    LengthLimitingTextInputFormatter(11),
                                    // Limit to 11 digits
                                  ],
                                ),
                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                CustomTextFormField(
                                  hintText: StringResources.DISTRICT_HINT,
                                  onChanged: (value) {
                                    // Although this won't be triggered due to readOnly, it's left here for consistency
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(SignUpDistrictChanged(value));
                                  },
                                  validator: (value) => value.isEmpty
                                      ? "Enter your district"
                                      : null,
                                  prefixIconSvgPath:
                                      ImageResources.DISTRICT_ICON,

                                  // Set the controller
                                ),
                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                CustomTextFormField(
                                  hintText: StringResources.PASSWORD_HINT,
                                  obscureText: !state.passwordVisibility,
                                  onChanged: (value) {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(SignUpPasswordChanged(value));
                                  },
                                  validator: (value) =>
                                      value.validatePassword(value),
                                  prefixIconSvgPath: ImageResources.LOCK_ICON,
                                  showSuffixIcon: true,
                                  onVisibilityTap: () {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(const PasswordVisibility());
                                  },
                                ),

                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                CustomTextFormField(
                                  hintText:
                                      StringResources.CONFIRM_PASSWORD_HINT,
                                  obscureText: !state.passwordVisibility,
                                  onChanged: (value) {
                                    context.read<SignUpScreenBloc>().add(
                                        SignUpConfirmPasswordChanged(value));
                                  },
                                  validator: (value) =>
                                      value.validateConfirmPassword(value),
                                  prefixIconSvgPath: ImageResources.LOCK_ICON,
                                  showSuffixIcon: true,
                                  onVisibilityTap: () {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(const PasswordVisibility());
                                  },
                                ),

                                Row(
                                  children: [
                                    Checkbox(
                                      value: state.isShowroomOwner,
                                      onChanged: (value) {
                                        context.read<SignUpScreenBloc>().add(
                                            SignUpShowroomOwnerChanged(
                                                value ?? false));
                                      },
                                    ),
                                    Text('I am a car showroom owner',style:  Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT.sp),),
                                  ],
                                ),

                                if (state.isShowroomOwner) ...[
                                  SizedBox(height: 16),
                                  CustomTextFormField(
                                    hintText: 'Enter showroom name',
                                    prefixIconSvgPath: ImageResources.STORE_ICON,
                                    onChanged: (value) {
                                      context.read<SignUpScreenBloc>().add(
                                          SignUpShowroomNameChanged(value));
                                    },
                                    validator: (value) {
                                      if (state.isShowroomOwner &&
                                          (value?.isEmpty ?? true)) {
                                        return 'Please enter showroom name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE.h,
                                bottom: Dimensions.PADDING_SIZE_SMALL.h),
                            child: BlocListener<SignUpScreenBloc,
                                SignUpScreenState>(
                              listener: (context, state) {
                                if (state.isSubmitting) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (state.isSubmitted) {

                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.success(
                                      message: "Registered successfully!",
                                    ),
                                  );
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RoutesName.DASHBOARD_SCREEN,
                                    (Route<dynamic> route) => false,
                                  );
                                } else if (state.submissionFailed) {
                                  Navigator.pop(context);

                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(
                                      message:state.errorMessage,
                                    ),
                                  );
                                }
                              },
                              child: CustomElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<SignUpScreenBloc>()
                                        .add(const SignUpSubmit());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please correct the errors in the form'),
                                      ),
                                    );
                                  }
                                },
                                text: StringResources.SIGNUP_BUTTON_TEXT,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
