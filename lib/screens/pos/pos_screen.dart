import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';
import '../../widgets/pos/payment_dialog.dart';
import '../../widgets/pos/product_card.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  String selectedTab = 'Products';
  String selectedCategory = 'All';
  String searchQuery = '';
  String sortBy = 'Name';

  final List<Map<String, dynamic>> cartItems = [];
  String paymentMethod = 'Cash';
  String orderType = 'In-Store';

  // Sample products data
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Espresso',
      'price': '95.00',
      'status': 'Available',
      'category': 'Hot',
    },
    {
      'name': 'Cappuccino',
      'price': '120.00',
      'status': 'Available',
      'category': 'Hot',
    },
    {
      'name': 'Iced Coffee',
      'price': '110.00',
      'status': 'Available',
      'category': 'Cold',
    },
    {
      'name': 'Frappe',
      'price': '135.00',
      'status': 'Available',
      'category': 'Cold',
    },
    {
      'name': 'Croissant',
      'price': '85.00',
      'status': 'Available',
      'category': 'Pastry',
    },
    {
      'name': 'Blueberry Muffin',
      'price': '75.00',
      'status': 'Available',
      'category': 'Pastry',
    },
    {
      'name': 'Chicken Rice',
      'price': '150.00',
      'status': 'Available',
      'category': 'Rice Meal',
    },
    {
      'name': 'Pork Adobo Rice',
      'price': '165.00',
      'status': 'Available',
      'category': 'Rice Meal',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    var filtered = products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product['category'] == selectedCategory;
      final matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (sortBy == 'Name') {
      filtered.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (sortBy == 'Price') {
      filtered.sort((a, b) {
        final priceA = double.parse(a['price']);
        final priceB = double.parse(b['price']);
        return priceA.compareTo(priceB);
      });
    }

    return filtered;
  }

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (double.parse(item['price']) * item['quantity']);
    });
  }

  double get tax {
    return subtotal * 0.12;
  }

  double get total {
    return subtotal + tax;
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingIndex = cartItems.indexWhere(
        (item) => item['name'] == product['name'],
      );

      if (existingIndex >= 0) {
        cartItems[existingIndex]['quantity']++;
      } else {
        cartItems.add({
          ...product,
          'quantity': 1,
        });
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentDialog(
        total: total,
        onConfirm: () {
          clearCart();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;

    return Scaffold(
      body: Row(
        children: [
          // Compact Sidebar
          const CompactSideBar(currentRoute: '/pos'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Point of Sale'),

                // Content
                Expanded(
                  child: Row(
                    children: [
                      // Left Section - Product Catalog
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: backgroundColor,
                          child: Column(
                            children: [
                              // Tab & Controls
                              Container(
                                padding: const EdgeInsets.all(24),
                                color: cardColor,
                                child: Column(
                                  children: [
                                    // Products / Services Tabs
                                    Row(
                                      children: [
                                        _TabButton(
                                          label: 'Products',
                                          isSelected: selectedTab == 'Products',
                                          onTap: () {
                                            setState(() {
                                              selectedTab = 'Products';
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 16),
                                        _TabButton(
                                          label: 'Services',
                                          isSelected: selectedTab == 'Services',
                                          onTap: () {
                                            setState(() {
                                              selectedTab = 'Services';
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Search & Sort
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Search products...',
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              filled: true,
                                              fillColor: backgroundColor,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                searchQuery = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: DropdownButton<String>(
                                            value: sortBy,
                                            underline: const SizedBox(),
                                            items: ['Name', 'Price', 'Category']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text('Sort by: $value'),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                sortBy = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Category Buttons
                              Container(
                                padding: const EdgeInsets.all(24),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _CategoryButton(
                                        label: 'All',
                                        isSelected: selectedCategory == 'All',
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = 'All';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      _CategoryButton(
                                        label: 'Cold',
                                        isSelected: selectedCategory == 'Cold',
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = 'Cold';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      _CategoryButton(
                                        label: 'Hot',
                                        isSelected: selectedCategory == 'Hot',
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = 'Hot';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      _CategoryButton(
                                        label: 'Pastry',
                                        isSelected:
                                            selectedCategory == 'Pastry',
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = 'Pastry';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      _CategoryButton(
                                        label: 'Rice Meal',
                                        isSelected:
                                            selectedCategory == 'Rice Meal',
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = 'Rice Meal';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Products Grid
                              Expanded(
                                child: GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return ProductCard(
                                      name: product['name'],
                                      price: product['price'],
                                      status: product['status'],
                                      onTap: () => addToCart(product),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right Section - Order Summary
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(-2, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Cart Items
                            Expanded(
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Current Order',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (cartItems.isNotEmpty)
                                          TextButton(
                                            onPressed: clearCart,
                                            child: const Text('Clear All'),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Cart Items List
                                  Expanded(
                                    child: cartItems.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart_outlined,
                                                  size: 64,
                                                  color: Colors.grey.shade300,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'No items added',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(20),
                                            itemCount: cartItems.length,
                                            itemBuilder: (context, index) {
                                              final item = cartItems[index];
                                              return _CartItem(
                                                name: item['name'],
                                                price: item['price'],
                                                quantity: item['quantity'],
                                                onAdd: () => addToCart(item),
                                                onRemove: () =>
                                                    removeFromCart(index),
                                                isDarkMode: isDarkMode,
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),

                            // Checkout Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Subtotal
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Subtotal',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '₱${subtotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Tax
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tax (12%)',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '₱${tax.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  // Total
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '₱${total.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Order Type Dropdown
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: DropdownButton<String>(
                                      value: orderType,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      items: [
                                        'In-Store',
                                        'Grab',
                                        'FoodPanda',
                                        'Takeout'
                                      ].map((String value) {
                                        IconData icon;
                                        switch (value) {
                                          case 'In-Store':
                                            icon = Icons.store;
                                            break;
                                          case 'Grab':
                                          case 'FoodPanda':
                                            icon = Icons.delivery_dining;
                                            break;
                                          case 'Takeout':
                                            icon = Icons.takeout_dining;
                                            break;
                                          default:
                                            icon = Icons.shopping_bag;
                                        }
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Icon(icon, size: 20),
                                              const SizedBox(width: 12),
                                              Text(value),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          orderType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Payment Method
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: DropdownButton<String>(
                                      value: paymentMethod,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      items: ['Cash', 'Card', 'GCash', 'Maya']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Icon(
                                                value == 'Cash'
                                                    ? Icons.money
                                                    : Icons.credit_card,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(value),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Confirm Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: cartItems.isEmpty
                                          ? null
                                          : _showPaymentDialog,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirm Order',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 2 : 0,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String name;
  final String price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool isDarkMode;

  const _CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final itemTotal = double.parse(price) * quantity;
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₱$price',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 20,
                color: Colors.red,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 20,
                color: Colors.green,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              '₱${itemTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
