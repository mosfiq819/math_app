import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'camera_screen.dart';
import 'solve_screen.dart';
import 'topics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('গণিত সমাধানকারী'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.calculate, size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text(
                      'গণিত সমস্যা সমাধান করুন',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'ভেক্টর, ম্যাট্রিক্স, ক্যালকুলাস এবং আরো অনেক কিছু',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Main Actions
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildActionCard(
                    context,
                    Icons.camera_alt,
                    'ছবি তুলুন',
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
                    },
                  ),
                  
                  _buildActionCard(
                    context,
                    Icons.keyboard,
                    'টাইপ করুন',
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SolveScreen()),
                      );
                    },
                  ),
                  
                  _buildActionCard(
                    context,
                    Icons.book,
                    'টপিক্স',
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopicsScreen()),
                      );
                    },
                  ),
                  
                  _buildActionCard(
                    context,
                    Icons.history,
                    'ইতিহাস',
                    Colors.purple,
                    () {
                      // Navigate to history
                    },
                  ),
                ],
              ),
            ),
            
            // Sample Math Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'উদাহরণ:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Math.tex(
                      r'\int x^2 dx = \frac{x^3}{3} + C',
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, 
                          String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}