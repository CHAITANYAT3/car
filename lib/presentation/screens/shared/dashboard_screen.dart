import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/app_models.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/service_card.dart';
import '../admin/admin_panel_screen.dart';
import '../customer/car_management_screen.dart';
import '../customer/service_center_screen.dart';
import '../customer/spare_parts_screen.dart';
import 'sales_analytics_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final app = context.watch<AppProvider>();
    final isAdmin = auth.currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Dashboard' : 'Customer Dashboard'),
        actions: [
          if (isAdmin && app.lowStock.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Chip(
                avatar: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                label: Text('${app.lowStock.length} Low Stock Alerts'),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ServiceCard(
            icon: Icons.directions_car,
            title: 'Car Management',
            subtitle: 'New cars, used cars, test drive, purchase flow',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarManagementScreen()),
            ),
          ),
          const SizedBox(height: 12),
          ServiceCard(
            icon: Icons.handyman,
            title: 'Spare Parts Store',
            subtitle: 'Buy parts and monitor stock levels',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SparePartsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          ServiceCard(
            icon: Icons.miscellaneous_services,
            title: 'Car Service Center',
            subtitle: 'Book Basic, Standard, or Premium services',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServiceCenterScreen()),
            ),
          ),
          const SizedBox(height: 12),
          ServiceCard(
            icon: Icons.sell,
            title: 'Sales & Analytics',
            subtitle: 'Track sales history and booking activity',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalesAnalyticsScreen()),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 12),
            ServiceCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin Panel',
              subtitle: 'Approve used cars and add new brands/models',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
