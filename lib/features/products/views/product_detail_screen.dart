import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Sold by ${widget.product.vendorName}', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                  const SizedBox(height: 10),
                  Text('\₹${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit}', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Text(widget.product.description, style: const TextStyle(fontSize: 16, height: 1.4)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 32),
                            onPressed: () => setState(() { if (quantity > 1) quantity--; }),
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 32),
                            onPressed: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                            label: const Text('Add to Cart', style: TextStyle(fontSize: 16, color: Colors.white)),
                            onPressed: () {
                              ref.read(cartProvider.notifier).addToCart(widget.product, quantity);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to bag! 🎉')));
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}