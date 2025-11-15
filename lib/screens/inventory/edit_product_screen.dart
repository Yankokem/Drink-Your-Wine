import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? productData;

  const EditProductScreen({super.key, this.productData});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _sizeController;
  late TextEditingController _initialStockController;
  late TextEditingController _currentStockController;
  late TextEditingController _priceController;
  late TextEditingController _reorderLevelController;
  late TextEditingController _supplierController;

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

  @override
  void initState() {
    super.initState();
    final product = widget.productData ?? {};

    _nameController = TextEditingController(text: product['name'] ?? '');
    _categoryController =
        TextEditingController(text: product['category'] ?? '');
    _sizeController = TextEditingController(text: product['size'] ?? '');
    _initialStockController = TextEditingController(
      text: product['initialStock']?.toString() ?? '0',
    );
    _currentStockController = TextEditingController(
      text: product['stock']?.toString() ?? '0',
    );
    _priceController = TextEditingController(
      text: product['price']?.toString() ?? '0',
    );
    _reorderLevelController = TextEditingController(
      text: product['reorderLevel']?.toString() ?? '0',
    );
    _supplierController = TextEditingController(
      text: product['supplier'] ?? '',
    );
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Update in database
      final updatedData = {
        'id': widget.productData?['id'],
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
          content: Text('Product updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _showStockAdjustmentDialog() {
    final adjustmentController = TextEditingController();
    String adjustmentType = 'add';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Adjust Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Add'),
                      value: 'add',
                      groupValue: adjustmentType,
                      onChanged: (value) {
                        setDialogState(() {
                          adjustmentType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Remove'),
                      value: 'remove',
                      groupValue: adjustmentType,
                      onChanged: (value) {
                        setDialogState(() {
                          adjustmentType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: adjustmentController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (pcs)',
                  hintText: '0',
                  suffix: Text('pcs'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Current Stock: ${_currentStockController.text} pcs',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final adjustment = int.tryParse(adjustmentController.text);
                if (adjustment != null) {
                  final currentStock = int.parse(_currentStockController.text);
                  final newStock = adjustmentType == 'add'
                      ? currentStock + adjustment
                      : currentStock - adjustment;

                  if (newStock >= 0) {
                    setState(() {
                      _currentStockController.text = newStock.toString();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Stock adjusted: ${adjustmentType == 'add' ? '+' : '-'}$adjustment pcs',
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Stock cannot be negative'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Adjust'),
            ),
          ],
        ),
      ),
    );
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
                const PageHeader(title: 'Edit Product'),

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
                                        initialValue:
                                            _categoryController.text.isEmpty
                                                ? null
                                                : _categoryController.text,
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
                                        initialValue:
                                            _sizeController.text.isEmpty
                                                ? null
                                                : _sizeController.text,
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
                                          labelText: 'Supplier',
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
                                              labelText: 'Reorder Level (pcs)',
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
                                          const SizedBox(height: 24),

                                          // Adjust Stock Button
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton.icon(
                                              onPressed:
                                                  _showStockAdjustmentDialog,
                                              icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 20),
                                              label: const Text('Adjust Stock'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                              ),
                                            ),
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
                                          onPressed: _updateProduct,
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
                                            'Update Product',
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
