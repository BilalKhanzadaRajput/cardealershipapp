import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/presentation/routes/routes.dart';
import 'package:cardealershipapp/presentation/routes/routes_name.dart';

import 'helper/constants/colors_resource.dart';
import 'helper/utils/theme_data.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp();
    print('Firebase successfully initialized');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  bool isLoggedIn = await isUserLoggedIn();

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorResources.PRIMARY_COLOR,
    ));
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeClass.appTheme,
        initialRoute: isLoggedIn ? RoutesName.DASHBOARD_SCREEN : RoutesName.LOG_IN_SCREEN,
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future<bool> isUserLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}