import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _selectedItems = [];

  double get _totalItemsPrice {
    return _selectedItems.fold(
        0.0, (sum, item) => sum + (item['price'] as double));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addItem() {
    String? selectedItem;

    final availableItems = [
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

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Item'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedItem,
                  decoration: const InputDecoration(
                    labelText: 'Select Item',
                    prefixIcon: Icon(Icons.coffee),
                    border: OutlineInputBorder(),
                  ),
                  items: availableItems
                      .map<DropdownMenuItem<String>>((item) =>
                          DropdownMenuItem<String>(
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
                    setDialogState(() {
                      selectedItem = value;
                    });
                  },
                ),
                if (selectedItem != null) ...[
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
                            'Price: ₱${(availableItems.firstWhere((item) => item['name'] == selectedItem)['price'] as double).toStringAsFixed(2)}',
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
              onPressed: () {
                if (selectedItem != null) {
                  final selectedItemData = availableItems.firstWhere(
                    (item) => item['name'] == selectedItem,
                  );

                  setState(() {
                    _selectedItems.add({
                      'name': selectedItem!,
                      'price': selectedItemData['price'],
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }

  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      if (_selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one item'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // TODO: Save to database
      final menuData = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'items': _selectedItems,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/menu'),
          Expanded(
            child: Column(
              children: [
                const PageHeader(title: 'Add Menu'),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column - Image & Basic Info
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
                                            Icons.restaurant_menu,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Menu Information',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),

                                    // Image Upload
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate,
                                            size: 60,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Click to upload image',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Menu Name
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Menu Name',
                                        hintText: 'e.g., Coffee Lovers Bundle',
                                        prefixIcon: Icon(Icons.menu_book),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter menu name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Price with Total Info
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _priceController,
                                          decoration: InputDecoration(
                                            labelText: 'Menu Price (₱)',
                                            hintText: '0.00',
                                            prefixIcon:
                                                const Icon(Icons.attach_money),
                                            suffixIcon: _selectedItems
                                                    .isNotEmpty
                                                ? Tooltip(
                                                    message:
                                                        'Total items: ₱${_totalItemsPrice.toStringAsFixed(2)}',
                                                    child: Icon(
                                                      Icons.info_outline,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
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
                                        if (_selectedItems.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.blue
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calculate,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Items Total: ₱${_totalItemsPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (_priceController
                                                    .text.isNotEmpty)
                                                  Text(
                                                    'Savings: ₱${(_totalItemsPrice - double.parse(_priceController.text)).toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: (_totalItemsPrice -
                                                                  double.parse(
                                                                      _priceController
                                                                          .text)) >
                                                              0
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // Description
                                    TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
                                        hintText:
                                            'Brief description of the menu...',
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

                          // Right Column - Items
                          Expanded(
                            child: Column(
                              children: [
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
                                                  Icons.fastfood,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Items',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: _addItem,
                                                icon: const Icon(
                                                    Icons.add_circle),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                iconSize: 32,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),

                                          // Items List
                                          Expanded(
                                            child: _selectedItems.isEmpty
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          size: 60,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          'No items added',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          'Click + to add items',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[400],
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    itemCount:
                                                        _selectedItems.length,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const Divider(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _selectedItems[index];
                                                      return ListTile(
                                                        leading: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Icon(
                                                            Icons.coffee,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          item['name'],
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '₱${item['price'].toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        trailing: IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              size: 20),
                                                          color: Colors.red,
                                                          onPressed: () =>
                                                              _removeItem(
                                                                  index),
                                                        ),
                                                      );
                                                    },
                                                  ),
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
                                        onPressed: _saveMenu,
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
                                          'Add Menu',
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
