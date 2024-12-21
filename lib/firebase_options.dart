import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web; // Kembali ke web jika platform-nya web
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDYcuMX_2t44bTIBRRsmBZBbDpWRr7h9PE",  // Ganti dengan API Key milikmu
    authDomain: "apt-app-5b3b2.firebaseapp.com",
    projectId: "apt-app-5b3b2",
    storageBucket: "apt-app-5b3b2.appspot.com", // Perbaiki URL storage bucket
    messagingSenderId: "379286118448",
    appId: "1:379286118448:web:e0664b57ac9a9b56ec4df5",
    measurementId: "G-VDXVQPHTQQ"
  );
}
