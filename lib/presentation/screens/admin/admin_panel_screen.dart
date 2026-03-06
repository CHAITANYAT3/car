import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCarDialog(context),
        label: const Text('Add Brand/Model'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Pending Used Car Requests', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...app.pendingUsedCars.map(
            (car) => Card(
              child: ListTile(
                title: Text('${car.brand} ${car.model}'),
                subtitle: Text('Seller: ${car.sellerName ?? '-'} • \$${car.price}'),
                trailing: FilledButton(
                  onPressed: () => app.approveUsedCar(car.id),
                  child: const Text('Approve'),
                ),
              ),
            ),
          ),
          const Divider(height: 28),
          Text('Low Stock Notifications', style: Theme.of(context).textTheme.titleMedium),
          ...app.lowStock.map(
            (item) => ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              title: Text(item.name),
              subtitle: Text('Remaining stock: ${item.stock}'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCarDialog(BuildContext context) async {
    final app = context.read<AppProvider>();
    final brand = TextEditingController();
    final model = TextEditingController();
    final price = TextEditingController();
    final desc = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Car Brand/Model'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: brand, decoration: const InputDecoration(labelText: 'Brand')),
              TextField(controller: model, decoration: const InputDecoration(labelText: 'Model')),
              TextField(controller: price, decoration: const InputDecoration(labelText: 'Price')),
              TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await app.addNewCar(
                brand: brand.text,
                model: model.text,
                price: double.tryParse(price.text) ?? 0,
                description: desc.text,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
