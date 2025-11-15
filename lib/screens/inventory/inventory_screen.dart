import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Name';

  final List<String> _categories = [
    'All',
    'Cups',
    'Containers',
    'Lids',
    'Utensils',
    'Packaging',
    'Others',
  ];

  final List<String> _sortOptions = [
    'Name',
    'Stock',
    'Price',
  ];

  // Mock data - replace with actual database calls
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Plastic Cup',
      'category': 'Cups',
      'size': 'Small',
      'initialStock': 500.0,
      'stock': 120.0,
      'price': 2.50,
      'reorderLevel': 100.0,
      'status': 'In Stock',
      'supplier': 'Container Supply Co.',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 2,
      'name': 'Plastic Cup',
      'category': 'Cups',
      'size': 'Medium',
      'initialStock': 500.0,
      'stock': 45.0,
      'price': 3.00,
      'reorderLevel': 100.0,
      'status': 'Low Stock',
      'supplier': 'Container Supply Co.',
      'lastUpdated': '2025-11-03',
    },
    {
      'id': 3,
      'name': 'Plastic Cup',
      'category': 'Cups',
      'size': 'Large',
      'initialStock': 400.0,
      'stock': 200.0,
      'price': 3.50,
      'reorderLevel': 80.0,
      'status': 'In Stock',
      'supplier': 'Container Supply Co.',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 4,
      'name': 'Plastic Cup',
      'category': 'Cups',
      'size': 'Extra Large',
      'initialStock': 300.0,
      'stock': 150.0,
      'price': 4.00,
      'reorderLevel': 60.0,
      'status': 'In Stock',
      'supplier': 'Container Supply Co.',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 5,
      'name': 'Styro Cup',
      'category': 'Cups',
      'size': 'Medium',
      'initialStock': 600.0,
      'stock': 0.0,
      'price': 2.00,
      'reorderLevel': 100.0,
      'status': 'Out of Stock',
      'supplier': 'Foam Products Inc.',
      'lastUpdated': '2025-11-02',
    },
    {
      'id': 6,
      'name': 'Paper Bowl',
      'category': 'Containers',
      'size': 'Regular',
      'initialStock': 400.0,
      'stock': 280.0,
      'price': 5.00,
      'reorderLevel': 80.0,
      'status': 'In Stock',
      'supplier': 'Eco Packaging',
      'lastUpdated': '2025-11-01',
    },
    {
      'id': 7,
      'name': 'Plastic Lid',
      'category': 'Lids',
      'size': 'Medium',
      'initialStock': 800.0,
      'stock': 620.0,
      'price': 1.50,
      'reorderLevel': 150.0,
      'status': 'In Stock',
      'supplier': 'Container Supply Co.',
      'lastUpdated': '2025-11-04',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = _products.where((product) {
      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    // Sort
    if (_sortBy == 'Name') {
      filtered.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_sortBy == 'Stock') {
      filtered.sort((a, b) => b['stock'].compareTo(a['stock']));
    } else if (_sortBy == 'Price') {
      filtered.sort((a, b) => b['price'].compareTo(a['price']));
    }

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
            'Are you sure you want to delete "${product['name']} - ${product['size']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p['id'] == product['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product['name']} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalProducts = _products.length;
    final lowStock = _products.where((p) => p['status'] == 'Low Stock').length;
    final outOfStock =
        _products.where((p) => p['status'] == 'Out of Stock').length;
    final totalValue =
        _products.fold<double>(0, (sum, p) => sum + (p['price'] * p['stock']));

    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/inventory'),
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Inventory Management'),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Cards
                          Row(
                            children: [
                              _InventoryStatCard(
                                title: 'Total Products',
                                count: totalProducts.toString(),
                                color: Colors.blue,
                                icon: Icons.inventory_2,
                              ),
                              const SizedBox(width: 16),
                              _InventoryStatCard(
                                title: 'Low Stock',
                                count: lowStock.toString(),
                                color: Colors.orange,
                                icon: Icons.warning_amber,
                              ),
                              const SizedBox(width: 16),
                              _InventoryStatCard(
                                title: 'Out of Stock',
                                count: outOfStock.toString(),
                                color: Colors.red,
                                icon: Icons.remove_circle,
                              ),
                              const SizedBox(width: 16),
                              _InventoryStatCard(
                                title: 'Total Value',
                                count: '₱${totalValue.toStringAsFixed(2)}',
                                color: Colors.green,
                                icon: Icons.account_balance_wallet,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Search + Filters + Add Button
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                                // Search Bar
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search employees...',
                                      prefixIcon: const Icon(Icons.search,
                                          size: 20, color: Colors.grey),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5F5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Sort By Dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Sort by: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _sortBy,
                                          items: _sortOptions.map((sort) {
                                            return DropdownMenuItem(
                                              value: sort,
                                              child: Text(sort),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _sortBy = value!;
                                            });
                                          },
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Add Product Button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/inventory/add');
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Product'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF6D4C41), // Brown
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Table
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                          flex: 1, child: _TableHeader('ID')),
                                      Expanded(
                                          flex: 3,
                                          child: _TableHeader('Product Name')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Category')),
                                      Expanded(
                                          flex: 2, child: _TableHeader('Size')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Initial Stock')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Current Stock')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Price')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Status')),
                                      Expanded(
                                          flex: 2,
                                          child: _TableHeader('Actions')),
                                    ],
                                  ),
                                ),

                                // Table Rows
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: _filteredProducts.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  itemBuilder: (context, index) {
                                    final product = _filteredProducts[index];
                                    return _ProductRow(
                                      id: product['id'],
                                      name: product['name'] as String,
                                      category: product['category'] as String,
                                      size: product['size'] as String,
                                      initialStock:
                                          product['initialStock'] as double,
                                      currentStock: product['stock'] as double,
                                      price: product['price'] as double,
                                      status: product['status'] as String,
                                      getStatusColor: _getStatusColor,
                                      onEdit: () => Navigator.pushNamed(
                                        context,
                                        '/inventory/edit',
                                        arguments: product,
                                      ),
                                      onDelete: () => _deleteProduct(product),
                                    );
                                  },
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

class _InventoryStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const _InventoryStatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final int id;
  final String name;
  final String category;
  final String size;
  final double initialStock;
  final double currentStock;
  final double price;
  final String status;
  final Color Function(String) getStatusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductRow({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.initialStock,
    required this.currentStock,
    required this.price,
    required this.status,
    required this.getStatusColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '#${id.toString().padLeft(4, '0')}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              size,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${initialStock.toInt()} pcs',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${currentStock.toInt()} pcs',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: currentStock < initialStock * 0.3
                    ? Colors.orange
                    : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₱${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: getStatusColor(status),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEdit,
                  color: Colors.blue,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: onDelete,
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
