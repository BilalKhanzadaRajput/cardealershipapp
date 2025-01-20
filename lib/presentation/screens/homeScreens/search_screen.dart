import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/businessLogic/bloc/searchScreenBloc/search_screen_bloc.dart';
import 'package:cardealershipapp/helper/constants/colors_resource.dart';
import 'package:cardealershipapp/helper/constants/dimensions_resource.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context
          .read<SearchScreenBloc>()
          .add(SearchDataEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        iconTheme: IconThemeData(
          color: ColorResources.WHITE_COLOR,
        ),
        centerTitle: true,
        title: Text(
          'Find My Poll',
          style: TextStyle(color: ColorResources.WHITE_COLOR),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.D_16.h),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by CNIC',
                labelStyle: TextStyle(
                  color: ColorResources.PRIMARY_COLOR,
                  fontSize: Dimensions.D_18.sp,
                  fontWeight: FontWeight.w400,
                ),
                hintText: 'Enter CNIC (e.g., 4464345455647)',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: Dimensions.D_16.sp,
                ),
                prefixIcon: const Icon(Icons.search,
                    color: ColorResources.PRIMARY_COLOR),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchScreenBloc>().add(
                        SearchDataEvent('')); // Trigger search with empty query
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.D_12.r),
                  borderSide: const BorderSide(
                      color: ColorResources.PRIMARY_COLOR, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.D_12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              style: TextStyle(
                fontSize: Dimensions.D_16.sp,
                color: Colors.black,
              ),
              onSubmitted: (query) {
                context.read<SearchScreenBloc>().add(SearchDataEvent(query));
              },
            ),
            BlocBuilder<SearchScreenBloc, SearchScreenState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isSuccess && state.data.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final userData = state.data[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: Dimensions.D_12.h),
                        padding: EdgeInsets.all(Dimensions.D_12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimensions.D_12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: Dimensions.D_25.h,
                              backgroundColor: ColorResources.PRIMARY_COLOR,
                              child: Text(
                                userData['name'][0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: Dimensions.D_24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.D_16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['name'],
                                    style: TextStyle(
                                      fontSize: Dimensions.D_18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'CNIC: ${userData['cnic']}',
                                    style: TextStyle(
                                      fontSize: Dimensions.D_16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'City: ${userData['city']}',
                                    style: TextStyle(
                                      fontSize: Dimensions.D_16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Polling Station: ${userData['Polling Station']}',
                                    style: TextStyle(
                                      fontSize: Dimensions.D_16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (_searchController.text.isEmpty) {
                  return const Center(child: Text(''));
                } else {
                  return const Center(child: Text('No results found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
