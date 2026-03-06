import 'package:flutter/material.dart';

import '../../domain/entities/app_models.dart';

Future<PaymentMethod?> showPaymentSheet(BuildContext context, double amount) {
  return showModalBottomSheet<PaymentMethod>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Amount Payable'),
              trailing: Text('\$${amount.toStringAsFixed(2)}'),
            ),
            ...PaymentMethod.values.map(
              (method) => ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: Text(method.name.toUpperCase()),
                onTap: () => Navigator.pop(context, method),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showPaymentSuccess(BuildContext context, PaymentMethod method) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 52),
      title: const Text('Payment Successful'),
      content: Text('Paid via ${method.name.toUpperCase()}'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
      ],
    ),
  );
}
