import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      color: Colors.white,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: ₹${product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            // decoration: BoxDecoration(
            //   color: const Color.fromARGB(255, 161, 112, 112),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.05),
            //       spreadRadius: 1,
            //       blurRadius: 10,
            //       offset: const Offset(0, -1),
            //     ),
            //   ],
            // ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addItem(product, 1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added to cart',
                        style: GoogleFonts.inter(),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.black.withOpacity(0.1),
                  elevation: 50,
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black.withOpacity(0.7);
                    }
                    return null;
                  }),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.grey[800]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(0, 7),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.0),
                        offset: const Offset(0, -2),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Add to cart',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 5),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
