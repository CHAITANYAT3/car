import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';

class SalesAnalyticsScreen extends StatelessWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final totalRevenue = app.sales.fold<double>(0, (sum, e) => sum + e.amount);
    return Scaffold(
      appBar: AppBar(title: const Text('Sales & Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Revenue Overview'),
              subtitle: Text('Total Sales: ${app.sales.length}'),
              trailing: Text('\$${totalRevenue.toStringAsFixed(2)}'),
            ),
          ),
          const SizedBox(height: 12),
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium),
          ...app.sales.map(
            (sale) => Card(
              child: ListTile(
                title: Text('${sale.customerName} • ${sale.carDetails}'),
                subtitle: Text(DateFormat.yMMMd().add_jm().format(sale.date)),
                trailing: Text('\$${sale.amount.toStringAsFixed(0)}'),
              ),
            ),
          ),
          const Divider(height: 28),
          Text('Service/Test Drive Bookings', style: Theme.of(context).textTheme.titleMedium),
          ...app.bookings.map(
            (booking) => ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${booking.type} • ${booking.itemId}'),
              subtitle: Text(DateFormat.yMMMd().add_jm().format(booking.schedule)),
            ),
          ),
        ],
      ),
    );
  }
}
