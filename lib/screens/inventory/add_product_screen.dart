import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _sizeController = TextEditingController();
  final _initialStockController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _priceController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  final _supplierController = TextEditingController();

  final List<String> _categories = [
    'Cups',
    'Containers',
    'Lids',
    'Utensils',
    'Packaging',
    'Others',
  ];

  final List<String> _sizes = [
    'Small',
    'Medium',
    'Large',
    'Extra Large',
    'Regular',
  ];

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to database
      final productData = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'size': _sizeController.text,
        'initialStock': int.parse(_initialStockController.text),
        'currentStock': int.parse(_currentStockController.text),
        'price': double.parse(_priceController.text),
        'reorderLevel': int.parse(_reorderLevelController.text),
        'supplier': _supplierController.text,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _sizeController.dispose();
    _initialStockController.dispose();
    _currentStockController.dispose();
    _priceController.dispose();
    _reorderLevelController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/inventory'),
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Add Product'),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column - Product Information
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Section Header
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.inventory_2,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Product Information',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),

                                      // Product Name
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Product Name',
                                          hintText: 'e.g., Plastic Cup',
                                          prefixIcon: Icon(Icons.shopping_bag),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter product name';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Category
                                      DropdownButtonFormField<String>(
                                        initialValue: null,
                                        decoration: const InputDecoration(
                                          labelText: 'Category',
                                          prefixIcon: Icon(Icons.category),
                                        ),
                                        items: _categories
                                            .map((cat) => DropdownMenuItem(
                                                  value: cat,
                                                  child: Text(cat),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _categoryController.text = value!;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a category';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Size
                                      DropdownButtonFormField<String>(
                                        initialValue: null,
                                        decoration: const InputDecoration(
                                          labelText: 'Size',
                                          prefixIcon: Icon(Icons.straighten),
                                        ),
                                        items: _sizes
                                            .map((size) => DropdownMenuItem(
                                                  value: size,
                                                  child: Text(size),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _sizeController.text = value!;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a size';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Supplier
                                      TextFormField(
                                        controller: _supplierController,
                                        decoration: const InputDecoration(
                                          labelText: 'Supplier (Optional)',
                                          hintText:
                                              'e.g., Container Supply Co.',
                                          prefixIcon: Icon(Icons.business),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Right Column - Stock & Pricing
                            Expanded(
                              child: Column(
                                children: [
                                  // Stock Information Card
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Section Header
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.storage,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Stock & Pricing',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 32),

                                          // Initial Stock
                                          TextFormField(
                                            controller: _initialStockController,
                                            decoration: const InputDecoration(
                                              labelText: 'Initial Stock (pcs)',
                                              hintText: '0',
                                              prefixIcon:
                                                  Icon(Icons.inventory_2),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter initial stock';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),

                                          // Current Stock
                                          TextFormField(
                                            controller: _currentStockController,
                                            decoration: const InputDecoration(
                                              labelText: 'Current Stock (pcs)',
                                              hintText: '0',
                                              prefixIcon: Icon(Icons.inventory),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter current stock';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),

                                          // Price
                                          TextFormField(
                                            controller: _priceController,
                                            decoration: const InputDecoration(
                                              labelText: 'Price per piece (₱)',
                                              hintText: '0.00',
                                              prefixIcon:
                                                  Icon(Icons.attach_money),
                                            ),
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*')),
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter price';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Invalid price';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),

                                          // Reorder Level
                                          TextFormField(
                                            controller: _reorderLevelController,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Reorder Level (pcs)',
                                              hintText: '0',
                                              prefixIcon:
                                                  Icon(Icons.warning_amber),
                                              helperText:
                                                  'Alert when stock falls below this level',
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter reorder level';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _saveProduct,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Add Product',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}