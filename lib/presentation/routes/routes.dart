import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/ComplaintScreenBloc/complaint_screen_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/DashboardScreenBloc/dashboard_screen_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/galleryScreenBloc/gallery_screen_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/jobPostingScreenBloc/job_posting_screen_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/searchScreenBloc/search_screen_bloc.dart';
import 'package:cardealershipapp/presentation/routes/routes_name.dart';
import 'package:cardealershipapp/presentation/screens/HomeScreens/complaint_screen.dart';
import 'package:cardealershipapp/presentation/screens/HomeScreens/dashboard_screen.dart';
import 'package:cardealershipapp/presentation/screens/homeScreens/gallery_screen.dart';

import '../../businessLogic/bloc/loginScreenBloc/login_screen_bloc.dart';
import '../../businessLogic/bloc/signUpScreenBloc/sign_up_screen_bloc.dart';
import '../screens/HomeScreens/job_posting_screen.dart';
import '../screens/HomeScreens/search_screen.dart';
import '../screens/authenticationScreens/log_in_screen.dart';
import '../screens/authenticationScreens/sign_up_screen.dart';
import '../screens/profileScreen/profile_screen.dart';
import '../../businessLogic/bloc/profileScreenBloc/profile_screen_bloc.dart';
import '../../businessLogic/bloc/profileScreenBloc/profile_screen_event.dart';

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
    
      case RoutesName.COMPLAINT_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<ComplaintScreenBloc>(
            create: (context) => ComplaintScreenBloc(),
            child: const ComplaintScreen(),
          ),
        );
      case RoutesName.SEARCH_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<SearchScreenBloc>(
            create: (context) => SearchScreenBloc(FirebaseFirestore.instance),
            child: const SearchScreen(),
          ),
        );
      case RoutesName.JOB_POSTING_SCREEN:
        return MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider<JobPostingScreenBloc>(
          create: (context) => JobPostingScreenBloc(),
            child: const JobPostingScreen(),
          ),
        );
      case RoutesName.GALLERY_SCREEN:
        return MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<GalleryBloc>(
            create: (context) => GalleryBloc(
              firebaseStorage: FirebaseStorage.instance,
            ),
            child: const GalleryScreen(),
          ),);
    }
    return null;
  }
}
