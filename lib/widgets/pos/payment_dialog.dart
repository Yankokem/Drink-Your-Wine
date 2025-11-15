import 'package:flutter/material.dart';

class PaymentDialog extends StatefulWidget {
  final double total;
  final VoidCallback onConfirm;

  const PaymentDialog({
    super.key,
    required this.total,
    required this.onConfirm,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double? amountReceived;
  bool showChange = false;
  bool isInsufficient = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _amountController.addListener(_autoCalculateChange);
  }

  @override
  void dispose() {
    _amountController.removeListener(_autoCalculateChange);
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _autoCalculateChange() {
    final text = _amountController.text;
    if (text.isEmpty) {
      setState(() {
        amountReceived = null;
        showChange = false;
        isInsufficient = false;
      });
      return;
    }
    final amount = double.tryParse(text);
    if (amount == null) return;
    setState(() {
      amountReceived = amount;
      if (amount >= widget.total) {
        showChange = true;
        isInsufficient = false;
      } else {
        showChange = true;
        isInsufficient = true;
      }
    });
  }

  void _setExactAmount() {
    setState(() {
      _amountController.text = widget.total.toStringAsFixed(2);
      amountReceived = widget.total;
      showChange = true;
      isInsufficient = false;
    });
  }

  double get change {
    if (amountReceived == null) return 0;
    return amountReceived! - widget.total;
  }

  Color get _changeContainerColor => isInsufficient
      ? Colors.red.withOpacity(0.1)
      : Colors.green.withOpacity(0.1);
  Color get _changeBorderColor => isInsufficient
      ? Colors.red.withOpacity(0.3)
      : Colors.green.withOpacity(0.3);
  Color get _changeTextColor => isInsufficient ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800, // Increased width for more breathing room
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3, // Left side takes 3 parts
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text('₱${widget.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _amountController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount Received',
                            hintText: 'Enter amount',
                            prefixText: '₱ ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            errorText:
                                isInsufficient ? 'Insufficient amount' : null,
                          ),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _setExactAmount,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Exact Amount'),
                            style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32), // Increased spacing
                  Expanded(
                    flex: 2, // Right side takes 2 parts (wider now)
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _changeContainerColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _changeBorderColor, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isInsufficient ? 'INSUFFICIENT' : 'CHANGE',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _changeTextColor,
                                letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isInsufficient
                                ? '-₱${(widget.total - amountReceived!).toStringAsFixed(2)}'
                                : '₱${change.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _changeTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: (!showChange || isInsufficient)
                        ? null
                        : () {
                            widget.onConfirm();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Order completed!'),
                                  backgroundColor: Colors.green),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Complete Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
