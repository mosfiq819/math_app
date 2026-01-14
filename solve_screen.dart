import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class SolveScreen extends StatefulWidget {
  const SolveScreen({super.key});

  @override
  State<SolveScreen> createState() => _SolveScreenState();
}

class _SolveScreenState extends State<SolveScreen> {
  final TextEditingController _problemController = TextEditingController();
  String _selectedTopic = 'auto';
  bool _isSolving = false;
  Map<String, dynamic>? _solution;
  String? _error;

  final List<String> _topics = [
    'auto',
    'vector',
    'matrix',
    'derivative',
    'integral',
    'limit',
    'equation'
  ];

  final Map<String, String> _topicNames = {
    'auto': 'স্বয়ংক্রিয় সনাক্তকরণ',
    'vector': 'ভেক্টর বীজগণিত',
    'matrix': 'ম্যাট্রিক্স',
    'derivative': 'ডেরিভেটিভ',
    'integral': 'ইন্টিগ্রাল',
    'limit': 'লিমিট',
    'equation': 'সমীকরণ'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('গণিত সমস্যা সমাধান'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Problem Input
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'আপনার গণিত সমস্যা লিখুন:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _problemController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'যেমন: x^2 এর ডেরিভেটিভ বের করুন',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Topic Selection
                    const Text(
                      'সমস্যার ধরন:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: _selectedTopic,
                      items: _topics.map((topic) {
                        return DropdownMenuItem(
                          value: topic,
                          child: Text(_topicNames[topic] ?? topic),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTopic = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Solve Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: _isSolving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Icon(Icons.check),
                        label: Text(
                          _isSolving ? 'সমাধান হচ্ছে...' : 'সমাধান করুন',
                          style: const TextStyle(fontSize: 16),
                        ),
                        onPressed: _isSolving ? null : _solveProblem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Solution Display
            if (_error != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            
            if (_solution != null && _solution!['success'])
              _buildSolutionCard(),
            
            // Math Keyboard
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MathField(
                  controller: _problemController,
                  variables: const ['x', 'y', 'z'],
                ),
              ),
            ),
            
            // Example Problems
            const SizedBox(height: 30),
            const Text(
              'উদাহরণ সমস্যা:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildExampleChip('ভেক্টর [1,2,3] এবং [4,5,6] এর ডট প্রোডাক্ট'),
                _buildExampleChip('ম্যাট্রিক্স [[1,2],[3,4]] এর ডিটারমিনেন্ট'),
                _buildExampleChip('x^2 + 3x এর ডেরিভেটিভ'),
                _buildExampleChip('∫ x^3 dx'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 30),
                const SizedBox(width: 10),
                const Text(
                  'সমাধান:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Answer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'উত্তর: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Math.tex(
                      _solution!['answer']?.toString().replaceAll('^', '^') ?? '',
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Steps
            const Text(
              'ধাপে ধাপে সমাধান:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._solution!['steps'].map<Widget>((step) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('কপি'),
                    onPressed: () {
                      // Copy to clipboard
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('শেয়ার'),
                    onPressed: () {
                      // Share solution
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _problemController.text = text;
      },
      backgroundColor: Colors.blue[50],
    );
  }

  Future<void> _solveProblem() async {
    if (_problemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('দয়া করে একটি সমস্যা লিখুন')),
      );
      return;
    }

    setState(() {
      _isSolving = true;
      _solution = null;
      _error = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.solveMathProblem(
        _problemController.text,
        _selectedTopic,
      );

      setState(() {
        _solution = result;
        if (!result['success']) {
          _error = result['error'] ?? 'সমস্যা সমাধানে ব্যর্থ হয়েছে';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'সংযোগ সমস্যা: $e';
      });
    } finally {
      setState(() {
        _isSolving = false;
      });
    }
  }
}