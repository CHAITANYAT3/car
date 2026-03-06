import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/app_models.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class ServiceCenterScreen extends StatefulWidget {
  const ServiceCenterScreen({super.key});

  @override
  State<ServiceCenterScreen> createState() => _ServiceCenterScreenState();
}

class _ServiceCenterScreenState extends State<ServiceCenterScreen> {
  final _brand = TextEditingController();
  final _model = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Car Service Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _brand, decoration: const InputDecoration(labelText: 'Car Brand')),
          TextField(controller: _model, decoration: const InputDecoration(labelText: 'Car Model')),
          const SizedBox(height: 10),
          ...app.servicePackages.map(
            (pkg) => Card(
              child: ListTile(
                leading: const Icon(Icons.build_circle_outlined),
                title: Text('${pkg.tier.name.toUpperCase()} Service'),
                subtitle: Text('${pkg.description}\n\$${pkg.price} • ${pkg.durationHours} hours'),
                isThreeLine: true,
                trailing: FilledButton(
                  onPressed: () async {
                    final date = await _pickDateTime(context);
                    if (date == null || auth.currentUser == null) return;
                    await app.bookService(
                      userId: auth.currentUser!.id,
                      carLabel: '${_brand.text} ${_model.text}',
                      tier: pkg.tier,
                      time: date,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Service added to cart and booked.')),
                      );
                    }
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDateTime(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (d == null || !context.mounted) return null;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
}
