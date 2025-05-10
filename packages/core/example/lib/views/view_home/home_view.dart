import 'package:core/core.dart';
import 'package:example/views/view_home/home_view_model.dart';
import 'package:example/views/view_home/models/product_model.dart';
import 'package:example/views/view_home/module/events.dart';
import 'package:example/views/view_home/module/states.dart';
import 'package:flutter/material.dart';

class HomeView extends MasterView<HomeViewModel, HomeViewEvent, HomeViewState> {
  HomeView({
    super.key,
    super.appBar,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
  });

  @override
  MasterViewTypes get currentView => super.currentView;

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    viewModel.add(HomeViewInitialEvent());
  }

  @override
  Widget viewContent(
      BuildContext context, HomeViewModel viewModel, HomeViewState state) {
    return Column(
      children: [
        AppBar(
          title: Text(arguments["productTitle"]),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => viewModel.loadProducts(),
              tooltip: 'Refresh Products',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _confirmClearAll(context, viewModel),
              tooltip: 'Clear All Products',
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              _buildBody(context, viewModel, state),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () => _showAddProductDialog(context, viewModel),
                  tooltip: 'Add Product',
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, HomeViewModel viewModel, HomeViewState state) {
    if (state is HomeViewLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is HomeViewErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadProducts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is HomeViewContentState) {
      return _buildProductsList(context, viewModel, state.products);
    }

    return const Center(child: Text('Loading...'));
  }

  Widget _buildProductsList(
      BuildContext context, HomeViewModel viewModel, List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add a new encrypted product',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _confirmDelete(context, viewModel, product),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: \$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                if (product.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Description: ${product.description}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                const SizedBox(height: 8),
                const Text(
                  '🔒 Stored with encryption',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context, HomeViewModel viewModel) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(resources.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                viewModel.addProduct(
                  nameController.text,
                  double.tryParse(priceController.text) ?? 0,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, HomeViewModel viewModel, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(resources.cancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteProduct(product.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete ALL products? '
          'This cannot be undone and all product data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(resources.cancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All products cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}