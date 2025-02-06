import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Replace with your actual API key
  const supabaseUrl = 'https://bndwsjneufdbocwgqcbe.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuZHdzam5ldWZkYm9jd2dxY2JlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MDI5MjIsImV4cCI6MjA1NDM3ODkyMn0.JzjepJzfz7cUki7bsCvDFICrBKFmbiAhBhvDdZ8oYNQ';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
}

class Dashboard extends StatelessWidget {
  // Example list of items to display in the carousel
  final List<String> carouselItems = [
    'https://via.placeholder.com/400x200.png?text=Slide+1',
    'https://via.placeholder.com/400x200.png?text=Slide+2',
    'https://via.placeholder.com/400x200.png?text=Slide+3',
    'https://via.placeholder.com/400x200.png?text=Slide+4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          // Carousel Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0, // Height of the carousel
              autoPlay: true, // Auto-play the carousel
              enlargeCenterPage: true, // Enlarge the center item
              aspectRatio: 16 / 9, // Aspect ratio of the carousel
              autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
              enableInfiniteScroll: true, // Infinite scrolling
              autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
              viewportFraction: 0.8, // Fraction of the viewport to show
            ),
            items: carouselItems.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(item), // Use NetworkImage for URLs
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Carousel Item',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),

          // Other dashboard content
          SizedBox(height: 20),
          Text(
            'Welcome to the Dashboard!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}