import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.toList()[index];
                      return Card(
                        elevation: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Image.network(
                            item.product.image,
                            width: 100,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item.product.title,
                            style: GoogleFonts.inter(),
                          ),
                          subtitle: Text(
                            '\₹${(item.product.price * item.quantity).toStringAsFixed(2)} ',
                            style: GoogleFonts.inter(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${item.quantity}x',
                                  style: GoogleFonts.inter()),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  cart.removeItem(item.product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total ammount:',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${cart.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
