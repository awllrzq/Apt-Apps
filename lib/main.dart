import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDYcuMX_2t44bTIBRRsmBZBbDpWRr7h9PE",
      authDomain: "apt-app-5b3b2.firebaseapp.com",
      databaseURL: "https://apt-app-5b3b2-default-rtdb.firebaseio.com",
      projectId: "apt-app-5b3b2",
      storageBucket: "apt-app-5b3b2.appspot.com",
      messagingSenderId: "379286118448",
      appId: "1:379286118448:web:e0664b57ac9a9b56ec4df5",
      measurementId: "G-VDXVQPHTQQ",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      home: const HomeScreen(),
    );
  }
}
