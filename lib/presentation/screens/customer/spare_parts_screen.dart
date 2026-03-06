import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../widgets/payment_sheet.dart';

class SparePartsScreen extends StatelessWidget {
  const SparePartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Spare Parts Store')),
      body: ListView.builder(
        itemCount: app.spareParts.length,
        itemBuilder: (_, i) {
          final p = app.spareParts[i];
          final isLow = p.stock < 5;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.precision_manufacturing, color: isLow ? Colors.red : null),
              title: Text(p.name),
              subtitle: Text('Price: \$${p.price.toStringAsFixed(2)} • Stock: ${p.stock}'),
              trailing: FilledButton(
                onPressed: p.stock == 0
                    ? null
                    : () async {
                        final method = await showPaymentSheet(context, p.price);
                        if (method == null || !context.mounted) return;
                        await app.buyPart(p.id);
                        if (context.mounted) showPaymentSuccess(context, method);
                      },
                child: const Text('Buy'),
              ),
            ),
          );
        },
      ),
    );
  }
}
