import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class EditItemScreen extends StatefulWidget {
  final Map<String, dynamic>? itemData;

  const EditItemScreen({super.key, this.itemData});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  late String _selectedContainer;
  final List<String> _containers = [
    'Plate (washable)',
    'Bowl (washable)',
    'Bowl',
    'Cup - S',
    'Cup - M',
    'Cup - L',
  ];

  List<Map<String, dynamic>> _ingredients = [];

  @override
  void initState() {
    super.initState();
    final item = widget.itemData ?? {};

    _nameController = TextEditingController(text: item['name'] ?? '');
    _priceController =
        TextEditingController(text: item['price']?.toString() ?? '');
    _descriptionController =
        TextEditingController(text: item['description'] ?? '');

    _selectedContainer = item['container'] ?? 'Cup - S';
    _ingredients = List<Map<String, dynamic>>.from(item['ingredients'] ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final quantityController = TextEditingController();
    String? selectedIngredient;

    final availableIngredients = [
      {'name': 'Espresso Beans', 'unit': 'g', 'stock': 15000.0},
      {'name': 'Arabica Beans', 'unit': 'g', 'stock': 15000.0},
      {'name': 'Whole Milk', 'unit': 'ml', 'stock': 5000.0},
      {'name': 'Sugar', 'unit': 'g', 'stock': 1000.0},
      {'name': 'Chocolate Syrup', 'unit': 'ml', 'stock': 800.0},
      {'name': 'Vanilla Syrup', 'unit': 'ml', 'stock': 750.0},
      {'name': 'Caramel Syrup', 'unit': 'ml', 'stock': 650.0},
      {'name': 'Whipped Cream', 'unit': 'g', 'stock': 500.0},
      {'name': 'Ice', 'unit': 'g', 'stock': 10000.0},
      {'name': 'Water', 'unit': 'ml', 'stock': 20000.0},
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Ingredient'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedIngredient,
                  decoration: const InputDecoration(
                    labelText: 'Ingredient',
                    prefixIcon: Icon(Icons.inventory_2),
                    border: OutlineInputBorder(),
                  ),
                  items: availableIngredients
                      .map<DropdownMenuItem<String>>(
                          (ingredient) => DropdownMenuItem<String>(
                                value: ingredient['name'] as String,
                                child: Text(ingredient['name'] as String),
                              ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedIngredient = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: const Icon(Icons.scale),
                    suffix: Text(
                      selectedIngredient != null
                          ? availableIngredients.firstWhere((ing) =>
                                  ing['name'] == selectedIngredient)['unit']
                              as String
                          : '',
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
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
                if (selectedIngredient != null &&
                    quantityController.text.isNotEmpty) {
                  final selectedIngredientData =
                      availableIngredients.firstWhere(
                    (ing) => ing['name'] == selectedIngredient,
                  );

                  setState(() {
                    _ingredients.add({
                      'name': selectedIngredient!,
                      'quantity': double.parse(quantityController.text),
                      'unit': selectedIngredientData['unit'],
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

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _updateItem() {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one ingredient'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // TODO: Update in database
      final itemData = {
        'id': widget.itemData?['id'],
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'container': _selectedContainer,
        'ingredients': _ingredients,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item updated successfully!'),
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
                const PageHeader(title: 'Edit Item'),
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
                                            Icons.coffee,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Item Information',
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

                                    // Item Name
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Item Name',
                                        prefixIcon: Icon(Icons.coffee_maker),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter item name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Price
                                    TextFormField(
                                      controller: _priceController,
                                      decoration: const InputDecoration(
                                        labelText: 'Price (₱)',
                                        prefixIcon: Icon(Icons.attach_money),
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter price';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Invalid price';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Container Type
                                    DropdownButtonFormField<String>(
                                      value: _selectedContainer,
                                      decoration: const InputDecoration(
                                        labelText: 'Container',
                                        prefixIcon: Icon(Icons.local_cafe),
                                      ),
                                      items: _containers
                                          .map((container) => DropdownMenuItem(
                                                value: container,
                                                child: Text(container),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedContainer = value!;
                                        });
                                      },
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

                          // Right Column - Ingredients
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
                                                  Icons.inventory_2,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Ingredients',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: _addIngredient,
                                                icon: const Icon(
                                                    Icons.add_circle),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                iconSize: 32,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),

                                          // Ingredients List
                                          Expanded(
                                            child: _ingredients.isEmpty
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
                                                          'No ingredients added',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    itemCount:
                                                        _ingredients.length,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const Divider(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final ingredient =
                                                          _ingredients[index];
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
                                                            Icons.grain,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          ingredient['name'],
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${ingredient['quantity']} ${ingredient['unit']}',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                        trailing: IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              size: 20),
                                                          color: Colors.red,
                                                          onPressed: () =>
                                                              _removeIngredient(
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
                                        onPressed: _updateItem,
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
                                          'Update Item',
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
