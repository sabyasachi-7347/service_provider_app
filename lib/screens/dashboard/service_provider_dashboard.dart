// screens/dashboard/service_provider_dashboard.dart
import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../utils/theme_provider.dart';

class ServiceProviderDashboard extends StatelessWidget {
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            ...items.map((item) => ListTile(
                  title: Text(item),
                  leading: Icon(Icons.assignment),
                )),
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
        title: Text('Service Provider Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection('Active Requests', activeRequests),
            _buildSection('Previous Requests', previousRequests),
            _buildSection('Feedbacks & Reviews', feedbacks),
          ],
        ),
      ),
    );
  }
}

