import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';

class ViewMenuScreen extends StatelessWidget {
  final Map<String, dynamic>? menuData;

  const ViewMenuScreen({super.key, this.menuData});

  @override
  Widget build(BuildContext context) {
    final menu = menuData ?? {};
    final items = menu['items'] as List? ?? [];

    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/menu'),
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        menu['name'] ?? 'Menu Details',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/menu/menu/edit',
                            arguments: menu,
                          );
                        },
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text('Edit'),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: menu['image'] != null
                                        ? Image.network(
                                            menu['image'],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.restaurant_menu,
                                                  size: 120,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.restaurant_menu,
                                              size: 120,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Details Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Basic Info Card
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.info_outline,
                                                  size: 24),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Basic Information',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 24),
                                          _InfoRow(
                                            'Menu Price',
                                            '₱${(menu['price'] ?? 0.0).toStringAsFixed(2)}',
                                          ),
                                          _InfoRow(
                                            'Total Items',
                                            '${items.length}',
                                          ),
                                          if (menu['description'] != null &&
                                              menu['description'].isNotEmpty)
                                            _InfoRow(
                                              'Description',
                                              menu['description'],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Items Card
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.fastfood,
                                                    size: 24),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Items (${items.length})',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(height: 24),
                                            Expanded(
                                              child: ListView.separated(
                                                itemCount: items.length,
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 12),
                                                itemBuilder: (context, index) {
                                                  final item = items[index];
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.coffee,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            item['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '₱${item['price'].toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
