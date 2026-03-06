import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/app_models.dart';
import '../../providers/auth_provider.dart';
import '../shared/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  UserRole _role = UserRole.customer;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: Lottie.network(
                          'https://assets2.lottiefiles.com/packages/lf20_1a8dx7zj.json',
                          repeat: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Car Showroom Management', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      SegmentedButton<UserRole>(
                        segments: const [
                          ButtonSegment(value: UserRole.customer, label: Text('Customer')),
                          ButtonSegment(value: UserRole.admin, label: Text('Admin')),
                        ],
                        selected: {_role},
                        onSelectionChanged: (val) => setState(() => _role = val.first),
                      ),
                      const SizedBox(height: 12),
                      if (_register) TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
                      TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                      ),
                      if (auth.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        icon: const Icon(Icons.login),
                        label: Text(_register ? 'Register' : 'Login'),
                        onPressed: () async {
                          final ok = _register
                              ? await auth.registerCustomer(
                                  name: _name.text,
                                  email: _email.text,
                                  password: _password.text,
                                )
                              : await auth.login(
                                  email: _email.text,
                                  password: _password.text,
                                  role: _role,
                                );
                          if (!context.mounted || !ok) return;
                          Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
                        },
                      ),
                      TextButton(
                        onPressed: () => setState(() => _register = !_register),
                        child: Text(_register ? 'Already have account? Login' : 'New user? Register'),
                      ),
                      const Text('Demo Admin: admin@showroom.com / admin123'),
                      const Text('Demo User: user@showroom.com / user123'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
