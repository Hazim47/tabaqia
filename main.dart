import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabaqai/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // أضف هذا السطر أيضاً

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TabaqAI());
}


class TabaqAI extends StatelessWidget {
  const TabaqAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'طبقAI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍽️ طبق AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'تعرف على طعامك باستخدام الذكاء الاصطناعي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, height: 250, fit: BoxFit.cover)
                      : Image.asset('assets/placeholder_food.png',
                          height: 250, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomButton(
                  icon: Icons.photo_library,
                  label: 'من المعرض',
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                _buildCustomButton(
                  icon: Icons.camera_alt,
                  label: 'من الكاميرا',
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'يرجى اختيار صورة طعام لتحليلها باستخدام الذكاء الاصطناعي.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
