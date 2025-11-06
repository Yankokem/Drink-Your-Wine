import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/compact_side_bar.dart';

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
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _reorderLevelController;
  late TextEditingController _supplierController;
  late TextEditingController _descriptionController;

  late String _selectedUnit;
  late String _selectedStatus;

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

  @override
  void initState() {
    super.initState();
    final product = widget.productData ?? {};

    _nameController = TextEditingController(text: product['name'] ?? '');
    _categoryController =
        TextEditingController(text: product['category'] ?? '');
    _stockController = TextEditingController(
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
    _descriptionController = TextEditingController(
      text: product['description'] ?? '',
    );

    _selectedUnit = product['unit'] ?? 'kg';
    _selectedStatus = product['status'] ?? 'In Stock';
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Update in database
      final updatedData = {
        'id': widget.productData?['id'],
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
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: '0.0',
                  suffix: Text(_selectedUnit),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Current Stock: ${_stockController.text} $_selectedUnit',
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
                final adjustment = double.tryParse(adjustmentController.text);
                if (adjustment != null) {
                  final currentStock = double.parse(_stockController.text);
                  final newStock = adjustmentType == 'add'
                      ? currentStock + adjustment
                      : currentStock - adjustment;

                  if (newStock >= 0) {
                    setState(() {
                      _stockController.text = newStock.toStringAsFixed(1);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Stock adjusted: ${adjustmentType == 'add' ? '+' : '-'}$adjustment $_selectedUnit',
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
                // Page Header with Quick Actions
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Product',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: _showStockAdjustmentDialog,
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text('Adjust Stock'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

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
                                      value: _categoryController.text.isEmpty
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

                                    // Supplier
                                    TextFormField(
                                      controller: _supplierController,
                                      decoration: const InputDecoration(
                                        labelText: 'Supplier',
                                        prefixIcon: Icon(Icons.business),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Description
                                    TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
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
                                                      return 'Please enter stock';
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
                                                child: DropdownButtonFormField<
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
