import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product.dart';

class AdminProductsView extends StatefulWidget {
  const AdminProductsView({super.key});

  @override
  State<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<AdminProductsView> {
  late final Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final response = await Supabase.instance.client.from('products').select();
    final products = (response as List).map((e) => Product.fromJson(e)).toList();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Products'),
        variant: AppBarVariant.primary,
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
