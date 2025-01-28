import 'package:cardealershipapp/presentation/screens/blogScreen/blog_screen.dart';
import 'package:cardealershipapp/presentation/screens/faqScreen/faq_screen.dart';
import 'package:cardealershipapp/presentation/screens/supportScreen/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/DashboardScreenBloc/dashboard_screen_bloc.dart';

import 'package:cardealershipapp/presentation/routes/routes_name.dart';
import 'package:cardealershipapp/presentation/screens/HomeScreens/dashboard_screen.dart';

import '../../businessLogic/bloc/loginScreenBloc/login_screen_bloc.dart';
import '../../businessLogic/bloc/signUpScreenBloc/sign_up_screen_bloc.dart';

import '../screens/authenticationScreens/log_in_screen.dart';
import '../screens/authenticationScreens/sign_up_screen.dart';
import '../screens/profileScreen/profile_screen.dart';
import '../../businessLogic/bloc/profileScreenBloc/profile_screen_bloc.dart';
import '../../businessLogic/bloc/profileScreenBloc/profile_screen_event.dart';
import '../screens/addCarScreen/add_car_screen.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.LOG_IN_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<LoginScreenBloc>(
            create: (context) => LoginScreenBloc(),
            child: const LogInScreen(),
          ),
        );
      case RoutesName.SIGN_UP_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<SignUpScreenBloc>(
            create: (context) => SignUpScreenBloc(),
            child: const SignUpScreen(),
          ),
        );
      case RoutesName.DASHBOARD_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<DashBoardScreenBloc>(
            create: (context) => DashBoardScreenBloc(),
            child: const DashBoardScreen(),
          ),
        );
            case RoutesName.PROFILE_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<ProfileScreenBloc>(
            create: (context) => ProfileScreenBloc()..add(LoadProfile()),
            child: const ProfileScreen(),
          ),
        );
      case RoutesName.ADD_CAR_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AddCarScreen(),
        );  case RoutesName.BLOG_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BlogScreen(),
        ); case RoutesName.FAQS_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FAQScreen(),
        ); case RoutesName.SUPPORT_SCEEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SupportScreen(),
        );
    }
    return null;
  }
}
