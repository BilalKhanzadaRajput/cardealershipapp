import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/constants/string_resources.dart';

class UnderDevelopmentScreen extends StatefulWidget {
  const UnderDevelopmentScreen({super.key});

  @override
  State<UnderDevelopmentScreen> createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(StringResources.UNDER_DEVELOPMENT_SCREEN)),
    );
  }
}
