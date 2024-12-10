import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ecommerce/providers/auth_provider.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter E-commerce',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor:
              Color(0xFFFAD6C3), //Color.fromARGB(255, 219, 216, 216),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor:
                Color(0xFFFAD6C3), // Color.fromARGB(255, 239, 235, 235),
            elevation: 50,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
