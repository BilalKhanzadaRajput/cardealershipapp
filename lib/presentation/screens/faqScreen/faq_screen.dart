import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                color: ColorResources.WHITE_COLOR,
              ),
        ),
        backgroundColor: ColorResources.PRIMARY_COLOR,
        iconTheme: IconThemeData(color: ColorResources.WHITE_COLOR),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          FAQItem(
            question: 'How do I create an account?',
            answer:
                'To create an account, go to the sign-up page and fill in your details.',
          ),
          FAQItem(
            question: 'How do I update my profile?',
            answer:
                'Go to the "Profile" section in the app to update your personal information.',
          ),
          FAQItem(
            question: 'How do I add car details?',
            answer:
                'To add car details, go to the "Car Management" section, click on "Add New Car," and fill in the required fields such as car model, year, color, and other relevant information.',
          ),
          FAQItem(
            question: 'How do I see car details?',
            answer:
                'To view car details, navigate to the "Car Management" section, select the car you want to view, and all its details including model, year, and other specifications will be displayed.',
          ),
          FAQItem(
            question: 'How can I contact customer support?',
            answer:
                'You can reach our customer support team through the "Support" section in the app.',
          ),
          FAQItem(
            question: 'What are your working hours?',
            answer:
                'Our customer support is available 24/7 for your assistance.',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          question,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: Dimensions.FONT_SIZE_MEDIUM.sp,
              color: ColorResources.PRIMARY_COLOR,
            ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: Dimensions.FONT_SIZE_SMALL.sp,
              color: ColorResources.BLACK_COLOR,
            ),),
          ),
        ],
      ),
    );
  }
}
