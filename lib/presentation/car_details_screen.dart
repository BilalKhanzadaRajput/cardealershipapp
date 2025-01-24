import 'package:flutter/material.dart';

class CarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> carData;

  const CarDetailsScreen({Key? key, required this.carData}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.carData['carMake']} ${widget.carData['carModel']}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fullscreen carousel for car images
          if (widget.carData['photoUrls']?.isNotEmpty ?? false)
            Expanded(
              child: PageView.builder(
                itemCount: widget.carData['photoUrls'].length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.carData['photoUrls'][index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/signup_logo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.carData['carMake']} ${widget.carData['carModel']} (${widget.carData['year']})',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: Rs. ${widget.carData['price']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.speed, size: 16),
                    SizedBox(width: 4),
                    Text('${widget.carData['mileage']} km'),
                    SizedBox(width: 16),
                    Icon(Icons.settings, size: 16),
                    SizedBox(width: 4),
                    Text(widget.carData['transmission']),
                    SizedBox(width: 16),
                    Icon(Icons.local_gas_station, size: 16),
                    SizedBox(width: 4),
                    Text(widget.carData['fuelType']),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Showroom: ${widget.carData['showroomName']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
