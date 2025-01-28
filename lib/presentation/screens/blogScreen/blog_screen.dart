import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart'; // For responsive design

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  // Track which card is expanded
  final List<bool> _expandedList = List.generate(carBlogs.length, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blogs',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
            color: ColorResources.WHITE_COLOR,
          ),
        ),
        backgroundColor: ColorResources.PRIMARY_COLOR,
        iconTheme: IconThemeData(color: ColorResources.WHITE_COLOR),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.builder(
          itemCount: carBlogs.length,
          itemBuilder: (context, index) {
            final carBlog = carBlogs[index];
            return BlogCard(
              imageUrl: carBlog['image'] ?? '',
              carName: carBlog['name'] ?? 'Unknown Car',
              description: carBlog['description'] ?? 'No description available',
              isExpanded: _expandedList[index],
              onTap: () {
                setState(() {
                  _expandedList[index] = !_expandedList[index]; // Toggle the expansion state
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final String imageUrl;
  final String carName;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;

  const BlogCard({
    super.key,
    required this.imageUrl,
    required this.carName,
    required this.description,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            Row(
              children: [
                // Car Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    imageUrl,
                    width: 120.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.w),
                // Car Name and Description
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carName,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                            color: ColorResources.PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: Dimensions.FONT_SIZE_MEDIUM.sp,
                            color: ColorResources.BLACK_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Show Full Description if Expanded
            if (isExpanded)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: Dimensions.FONT_SIZE_MEDIUM.sp,
                    color: ColorResources.BLACK_COLOR,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String?>> carBlogs = [
  {
    'image': 'assets/images/honda_civic.jpg',
    'name': 'Honda Civic',
    'description': '''The Honda Civic is a compact car that has gained popularity worldwide for its reliability, fuel efficiency, and sleek design. With various trims and engine options, the Civic offers something for almost every type of driver. The latest models feature advanced safety features, a smooth ride, and modern infotainment systems. Fuel efficiency is one of the car's strong suits, making it an ideal choice for those who prioritize economy. Honda's reputation for long-lasting reliability means the Civic is often regarded as a great investment. Whether you're looking for a daily commuter or a sporty compact car, the Honda Civic delivers. It remains a top choice for first-time car buyers and seasoned drivers alike. The cabin is comfortable, with ample legroom and a user-friendly layout. While the exterior design has evolved over the years, it still retains the signature Civic style. In addition to its practicality, the Civic has a reputation for being fun to drive with its nimble handling. It's no wonder the Civic has been one of Honda's best-selling models for decades.''',
  },
  {
    'image': 'assets/images/honda_city.jpg',
    'name': 'Honda City',
    'description': '''The Honda City is a subcompact sedan known for its comfortable ride, stylish design, and excellent fuel efficiency. Since its debut, the City has been a favorite in markets around the world, especially in Asia. With a sleek and modern exterior, the City offers a premium look at an affordable price. Its spacious interior provides plenty of room for passengers, and the large trunk offers significant storage space. The City comes equipped with a variety of features such as a touchscreen infotainment system, Bluetooth connectivity, and modern safety features. Honda has always focused on providing a quiet and smooth ride, and the City is no exception. It is equipped with a reliable engine, providing a balance of power and fuel economy. The compact size makes it ideal for city driving and parking, while its sophisticated features make it feel like a more premium car. The latest model also includes driver-assist features, improving the overall driving experience. Whether you're using it for daily commuting or road trips, the Honda City is versatile and dependable.''',
  },
  {
    'image': 'assets/images/suzuki_mehran.jpg',
    'name': 'Suzuki Mehran',
    'description': '''The Suzuki Mehran has been a staple in the subcompact car market for many years. Known for its simplicity and affordability, the Mehran became one of the most popular choices for first-time car buyers in various countries, particularly in South Asia. Despite its small size, the Mehran offers great fuel efficiency and is easy to maneuver, making it perfect for tight city streets. Over the years, the car has undergone minimal changes, keeping its core design intact. The Mehran’s basic features, such as manual windows and air conditioning, are sufficient for daily driving needs. Its reliability and low cost of ownership have made it a preferred choice for budget-conscious individuals. The small engine provides enough power for city driving, while its small footprint allows for easy parking. The car's minimalist design and straightforward mechanics ensure that maintenance costs remain low. While it lacks the advanced features of modern cars, the Mehran's no-frills approach appeals to many drivers who prioritize affordability over luxury. It's an affordable, reliable car that continues to have a loyal customer base.''',
  },
  {
    'image': 'assets/images/suzuki_alto.jpg',
    'name': 'Suzuki Alto',
    'description': '''The Suzuki Alto is a compact city car that has become one of Suzuki's most recognizable models. Designed with practicality and efficiency in mind, the Alto is perfect for those looking for a small, fuel-efficient car for urban environments. Its compact size allows it to fit into tight parking spots and navigate through congested traffic with ease. The Alto’s small engine offers excellent fuel economy, making it a cost-effective option for city dwellers. Despite its compact size, the Alto provides a surprisingly comfortable ride, with a simple but functional interior. The cabin is well-equipped with essential features such as air conditioning, a basic infotainment system, and adequate legroom for passengers. Suzuki has ensured that the Alto remains affordable, which is one of its biggest selling points. The car's low maintenance cost and strong resale value make it a solid choice for budget-conscious buyers. Its high fuel efficiency, practicality, and reliability make it a top pick for city living, where space and budget are often limited.''',
  },
  {
    'image': 'assets/images/suzuki_cultus.jpg',
    'name': 'Suzuki Cultus',
    'description': '''The Suzuki Cultus is a compact hatchback that has become a favorite among budget-conscious car buyers. Known for its fuel efficiency, practicality, and affordable price tag, the Cultus offers great value for money. The design is simple yet modern, with clean lines and a compact footprint. Inside, the Cultus features a surprisingly spacious cabin for its size, offering ample legroom and headroom for both front and rear passengers. The car is equipped with modern safety features such as airbags, anti-lock brakes, and stability control. The engine provides a good balance of power and fuel economy, making it a great choice for daily commutes and longer drives. The Cultus is also easy to maintain, thanks to its straightforward mechanical design. With a reputation for durability and low maintenance costs, it continues to be a popular choice for individuals and families alike. Suzuki has ensured that the Cultus offers a comfortable and smooth driving experience, whether you're navigating city streets or taking it on a longer road trip. The Cultus combines practicality, affordability, and efficiency in one well-rounded package.''',
  },
];

