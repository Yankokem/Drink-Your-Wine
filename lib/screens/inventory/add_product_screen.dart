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
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  final _supplierController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedUnit = 'kg';
  String _selectedStatus = 'In Stock';

  final List<String> _units = ['kg', 'L', 'pcs', 'btl', 'box', 'pack'];
  final List<String> _statuses = ['In Stock', 'Low Stock', 'Out of Stock'];

  final List<String> _categories = [
    'Coffee',
    'Dairy',
    'Supplies',
    'Packaging',
    'Flavors',
    'Snacks',
    'Beverages',
    'Other',
  ];

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to database
      final productData = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'stock': double.parse(_stockController.text),
        'unit': _selectedUnit,
        'price': double.parse(_priceController.text),
        'reorderLevel': double.parse(_reorderLevelController.text),
        'supplier': _supplierController.text,
        'description': _descriptionController.text,
        'status': _selectedStatus,
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
    _stockController.dispose();
    _priceController.dispose();
    _reorderLevelController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                        hintText: 'e.g., Espresso Beans',
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
                                      value: null,
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

                                    // Supplier
                                    TextFormField(
                                      controller: _supplierController,
                                      decoration: const InputDecoration(
                                        labelText: 'Supplier (Optional)',
                                        hintText: 'e.g., Coffee Masters Inc.',
                                        prefixIcon: Icon(Icons.business),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Description
                                    TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description (Optional)',
                                        hintText:
                                            'Additional product information...',
                                        prefixIcon: Icon(Icons.description),
                                      ),
                                      maxLines: 3,
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

                                          // Stock and Unit
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: TextFormField(
                                                  controller: _stockController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Current Stock',
                                                    hintText: '0.0',
                                                    prefixIcon:
                                                        Icon(Icons.inventory),
                                                  ),
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d*')),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter stock quantity';
                                                    }
                                                    if (double.tryParse(
                                                            value) ==
                                                        null) {
                                                      return 'Invalid number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child:
                                                    DropdownButtonFormField<
                                                        String>(
                                                  value: _selectedUnit,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Unit',
                                                  ),
                                                  items: _units
                                                      .map((unit) =>
                                                          DropdownMenuItem(
                                                            value: unit,
                                                            child: Text(unit),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedUnit = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),

                                          // Price
                                          TextFormField(
                                            controller: _priceController,
                                            decoration: const InputDecoration(
                                              labelText: 'Price (₱)',
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
                                              labelText: 'Reorder Level',
                                              hintText: '0.0',
                                              prefixIcon:
                                                  Icon(Icons.warning_amber),
                                              helperText:
                                                  'Alert when stock falls below this level',
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
                                                return 'Please enter reorder level';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Invalid number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 32),

                                          // Status Selection
                                          const Text(
                                            'Status',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _StatusOption(
                                                  label: 'In Stock',
                                                  icon: Icons.check_circle,
                                                  color: Colors.green,
                                                  isSelected: _selectedStatus ==
                                                      'In Stock',
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedStatus =
                                                          'In Stock';
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _StatusOption(
                                                  label: 'Low Stock',
                                                  icon: Icons.warning,
                                                  color: Colors.orange,
                                                  isSelected: _selectedStatus ==
                                                      'Low Stock',
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedStatus =
                                                          'Low Stock';
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _StatusOption(
                                                  label: 'Out',
                                                  icon: Icons.cancel,
                                                  color: Colors.red,
                                                  isSelected: _selectedStatus ==
                                                      'Out of Stock',
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedStatus =
                                                          'Out of Stock';
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}