import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IngredientSelectorForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const IngredientSelectorForm({
    super.key,
    required this.onAdd,
  });

  @override
  State<IngredientSelectorForm> createState() => _IngredientSelectorFormState();
}

class _IngredientSelectorFormState extends State<IngredientSelectorForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedIngredient;
  final _quantityController = TextEditingController();

  // Mock ingredients from inventory
  final List<Map<String, dynamic>> _availableIngredients = [
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

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      final selectedIngredientData = _availableIngredients.firstWhere(
        (ing) => ing['name'] == _selectedIngredient,
      );

      widget.onAdd({
        'name': _selectedIngredient!,
        'quantity': double.parse(_quantityController.text),
        'unit': selectedIngredientData['unit'],
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Ingredient'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedIngredient,
              decoration: const InputDecoration(
                labelText: 'Ingredient',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              items: _availableIngredients
                  .map<DropdownMenuItem<String>>(
                      (ingredient) => DropdownMenuItem<String>(
                            value: ingredient['name'] as String,
                            child: Text(ingredient['name'] as String),
                          ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIngredient = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an ingredient';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                prefixIcon: const Icon(Icons.scale),
                suffix: Text(
                  _selectedIngredient != null
                      ? _availableIngredients.firstWhere(
                          (ing) => ing['name'] == _selectedIngredient)['unit']
                      : '',
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Quantity must be greater than 0';
                }
                return null;
              },
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
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
