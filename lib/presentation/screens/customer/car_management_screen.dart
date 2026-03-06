import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/app_models.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/payment_sheet.dart';

class CarManagementScreen extends StatelessWidget {
  const CarManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Car Management'),
          bottom: const TabBar(tabs: [Tab(text: 'New Cars'), Tab(text: 'Used Cars')]),
        ),
        body: const TabBarView(children: [_CarList(condition: CarCondition.newCar), _CarList(condition: CarCondition.usedCar)]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _sellMyCarDialog(context),
          icon: const Icon(Icons.add_road),
          label: const Text('Sell My Car'),
        ),
      ),
    );
  }

  Future<void> _sellMyCarDialog(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final app = context.read<AppProvider>();
    final brand = TextEditingController();
    final model = TextEditingController();
    final price = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit Used Car Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: brand, decoration: const InputDecoration(labelText: 'Brand')),
            TextField(controller: model, decoration: const InputDecoration(labelText: 'Model')),
            TextField(controller: price, decoration: const InputDecoration(labelText: 'Selling Price')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await app.submitUsedCarRequest(
                seller: auth.currentUser?.name ?? 'Unknown',
                brand: brand.text,
                model: model.text,
                price: double.tryParse(price.text) ?? 0,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _CarList extends StatelessWidget {
  const _CarList({required this.condition});
  final CarCondition condition;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final auth = context.read<AuthProvider>();
    final cars = condition == CarCondition.newCar ? app.newCars : app.usedCars;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cars.length,
      itemBuilder: (_, index) {
        final car = cars[index];
        return Hero(
          tag: car.id,
          child: Card(
            child: ListTile(
              title: Text('${car.brand} ${car.model}'),
              subtitle: Text('${car.description}\n\$${car.price.toStringAsFixed(0)}'),
              isThreeLine: true,
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    tooltip: 'Book test drive',
                    onPressed: () async {
                      final schedule = await _pickDateTime(context);
                      if (schedule == null || auth.currentUser == null) return;
                      await app.bookTestDrive(
                        userId: auth.currentUser!.id,
                        carId: '${car.brand} ${car.model}',
                        time: schedule,
                      );
                    },
                  ),
                  FilledButton(
                    onPressed: () async {
                      final method = await showPaymentSheet(context, car.price);
                      if (method == null || auth.currentUser == null || !context.mounted) return;
                      await app.purchaseCar(customerName: auth.currentUser!.name, car: car);
                      if (context.mounted) showPaymentSuccess(context, method);
                    },
                    child: const Text('Buy'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<DateTime?> _pickDateTime(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 120)),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
