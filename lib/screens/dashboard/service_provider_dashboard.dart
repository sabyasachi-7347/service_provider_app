// screens/dashboard/service_provider_dashboard.dart
import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../utils/theme_provider.dart';

class ServiceProviderDashboard extends StatelessWidget {
  const ServiceProviderDashboard({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No records available.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              )
            else
              ...items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.assignment_turned_in_outlined, color: color),
                    title: Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final activeRequests = ['Request #101', 'Request #102'];
    final previousRequests = ['Request #099', 'Request #098'];
    final feedbacks = ['Great service!', 'Could be faster'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your service requests and recent customer feedback quickly.',
                      style: TextStyle(color: Color(0xFF047857)),
                    ),
                  ],
                ),
              ),
              _buildSection(
                title: 'Active Requests',
                icon: Icons.flash_on_outlined,
                color: const Color(0xFF2563EB),
                items: activeRequests,
              ),
              _buildSection(
                title: 'Previous Requests',
                icon: Icons.history_outlined,
                color: const Color(0xFF7C3AED),
                items: previousRequests,
              ),
              _buildSection(
                title: 'Feedbacks & Reviews',
                icon: Icons.rate_review_outlined,
                color: const Color(0xFF059669),
                items: feedbacks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

