import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  final List<String> _categories = [
    'All',
    'Coffee',
    'Dairy',
    'Supplies',
    'Packaging',
    'Flavors',
    'Snacks',
  ];

  final List<String> _statusFilters = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  // Mock data - replace with actual database calls
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Espresso Beans',
      'category': 'Coffee',
      'stock': 2.5,
      'unit': 'kg',
      'price': 850.00,
      'reorderLevel': 5.0,
      'status': 'Low Stock',
      'supplier': 'Coffee Masters Inc.',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 2,
      'name': 'Arabica Beans',
      'category': 'Coffee',
      'stock': 15.0,
      'unit': 'kg',
      'price': 1200.00,
      'reorderLevel': 10.0,
      'status': 'In Stock',
      'supplier': 'Coffee Masters Inc.',
      'lastUpdated': '2025-11-03',
    },
    {
      'id': 3,
      'name': 'Whole Milk',
      'category': 'Dairy',
      'stock': 5.0,
      'unit': 'L',
      'price': 280.00,
      'reorderLevel': 8.0,
      'status': 'Low Stock',
      'supplier': 'Fresh Dairy Co.',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 4,
      'name': 'Sugar',
      'category': 'Supplies',
      'stock': 1.0,
      'unit': 'kg',
      'price': 85.00,
      'reorderLevel': 3.0,
      'status': 'Low Stock',
      'supplier': 'General Supplies',
      'lastUpdated': '2025-11-04',
    },
    {
      'id': 5,
      'name': 'Paper Cups (Medium)',
      'category': 'Packaging',
      'stock': 0.0,
      'unit': 'pcs',
      'price': 2.50,
      'reorderLevel': 50.0,
      'status': 'Out of Stock',
      'supplier': 'Pack Solutions',
      'lastUpdated': '2025-11-02',
    },
    {
      'id': 6,
      'name': 'Chocolate Syrup',
      'category': 'Flavors',
      'stock': 8.0,
      'unit': 'btl',
      'price': 320.00,
      'reorderLevel': 5.0,
      'status': 'In Stock',
      'supplier': 'Flavor House',
      'lastUpdated': '2025-11-01',
    },
    {
      'id': 7,
      'name': 'Croissants',
      'category': 'Snacks',
      'stock': 24.0,
      'unit': 'pcs',
      'price': 45.00,
      'reorderLevel': 10.0,
      'status': 'In Stock',
      'supplier': 'Bakery Delights',
      'lastUpdated': '2025-11-04',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'All' || product['status'] == _selectedStatus;
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
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

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow('Category', product['category']),
              _DetailRow(
                  'Current Stock', '${product['stock']} ${product['unit']}'),
              _DetailRow('Price', '₱${product['price'].toStringAsFixed(2)}'),
              _DetailRow('Reorder Level',
                  '${product['reorderLevel']} ${product['unit']}'),
              _DetailRow('Supplier', product['supplier']),
              _DetailRow('Last Updated', product['lastUpdated']),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Status: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(product['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            _getStatusColor(product['status']).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      product['status'],
                      style: TextStyle(
                        color: _getStatusColor(product['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/inventory/edit',
                arguments: product,
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
            'Are you sure you want to delete "${product['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete functionality
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
    final filteredProducts = _filteredProducts;
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
                // Top Bar
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
                      Text(
                        'Inventory Management',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/inventory/add'),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Total Products',
                                value: totalProducts.toString(),
                                icon: Icons.inventory_2,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Low Stock',
                                value: lowStock.toString(),
                                icon: Icons.warning_amber,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Out of Stock',
                                value: outOfStock.toString(),
                                icon: Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Total Value',
                                value: '₱${totalValue.toStringAsFixed(2)}',
                                icon: Icons.attach_money,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Filters
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Search
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    onChanged: (value) => setState(() {
                                      _searchQuery = value;
                                    }),
                                    decoration: InputDecoration(
                                      hintText: 'Search products...',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Category Filter
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedCategory,
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                    ),
                                    items: _categories
                                        .map((cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(cat),
                                            ))
                                        .toList(),
                                    onChanged: (value) => setState(() {
                                      _selectedCategory = value!;
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Status Filter
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedStatus,
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                    ),
                                    items: _statusFilters
                                        .map((status) => DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ))
                                        .toList(),
                                    onChanged: (value) => setState(() {
                                      _selectedStatus = value!;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Products Table
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Products (${filteredProducts.length})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.refresh),
                                          onPressed: () {
                                            setState(() {});
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.file_download),
                                          onPressed: () {
                                            // TODO: Export functionality
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.grey.shade100,
                                    ),
                                    columnSpacing: 20,
                                    columns: const [
                                      DataColumn(label: Text('Product Name')),
                                      DataColumn(label: Text('Category')),
                                      DataColumn(
                                          label: Text('Stock'), numeric: true),
                                      DataColumn(label: Text('Unit')),
                                      DataColumn(
                                          label: Text('Price'), numeric: true),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Actions')),
                                    ],
                                    rows: filteredProducts
                                        .map(
                                          (product) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  product['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _showProductDetails(
                                                        product),
                                              ),
                                              DataCell(
                                                  Text(product['category'])),
                                              DataCell(
                                                Text(
                                                  product['stock'].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: product['stock'] <=
                                                            product[
                                                                'reorderLevel']
                                                        ? Colors.orange
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(product['unit'])),
                                              DataCell(Text(
                                                  '₱${product['price'].toStringAsFixed(2)}')),
                                              DataCell(
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                            product['status'])
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: _getStatusColor(
                                                              product['status'])
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    product['status'],
                                                    style: TextStyle(
                                                      color: _getStatusColor(
                                                          product['status']),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          size: 20),
                                                      onPressed: () =>
                                                          Navigator.pushNamed(
                                                        context,
                                                        '/inventory/edit',
                                                        arguments: product,
                                                      ),
                                                      color: Colors.blue,
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          size: 20),
                                                      onPressed: () =>
                                                          _deleteProduct(
                                                              product),
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
