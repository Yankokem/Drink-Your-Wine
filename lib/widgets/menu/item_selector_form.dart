import 'package:flutter/material.dart';

class ItemSelectorForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const ItemSelectorForm({
    super.key,
    required this.onAdd,
  });

  @override
  State<ItemSelectorForm> createState() => _ItemSelectorFormState();
}

class _ItemSelectorFormState extends State<ItemSelectorForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedItem;

  // Mock items
  final List<Map<String, dynamic>> _availableItems = [
    {'name': 'Espresso', 'price': 120.00},
    {'name': 'Cappuccino', 'price': 150.00},
    {'name': 'Latte', 'price': 155.00},
    {'name': 'Americano', 'price': 110.00},
    {'name': 'Mocha', 'price': 165.00},
    {'name': 'Macchiato', 'price': 140.00},
    {'name': 'Flat White', 'price': 160.00},
    {'name': 'Croissant', 'price': 80.00},
    {'name': 'Chocolate Chip Cookie', 'price': 65.00},
    {'name': 'Blueberry Muffin', 'price': 95.00},
  ];

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      final selectedItemData = _availableItems.firstWhere(
        (item) => item['name'] == _selectedItem,
      );

      widget.onAdd({
        'name': _selectedItem!,
        'price': selectedItemData['price'],
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedItem,
              decoration: const InputDecoration(
                labelText: 'Select Item',
                prefixIcon: Icon(Icons.coffee),
                border: OutlineInputBorder(),
              ),
              items: _availableItems
                  .map<DropdownMenuItem<String>>(
                      (item) => DropdownMenuItem<String>(
                            value: item['name'] as String,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['name'] as String),
                                Text(
                                  '₱${(item['price'] as double).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an item';
                }
                return null;
              },
            ),
            if (_selectedItem != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Price: ₱${_availableItems.firstWhere((item) => item['name'] == _selectedItem)['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
