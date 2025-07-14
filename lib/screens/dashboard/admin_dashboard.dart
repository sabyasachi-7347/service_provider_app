// screens/dashboard/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../utils/theme_provider.dart';
import '../admin/all_consumers_screen.dart'; // Import this
import '../admin/all_service_providers_screen.dart';
import '../admin/all_complaints_requests_screen.dart';

class AdminDashboard extends StatelessWidget {
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void _onTileTap(BuildContext context, String title) {
    // Handle tile navigation or show data
    debugPrint('Tapped on $title');
     if (title == 'All Consumers') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllConsumersScreen()),
    );
  } else if (title == 'Service Providers') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllServiceProvidersScreen()),
    );
  } else if (title == 'Complaints / Requests') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AllComplaintsRequestsScreen()));
  }
  // Handle other tiles here
  }

  Widget _buildTile(String title, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () => _onTileTap(context,title),
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildTile('All Consumers', Icons.group, Colors.blue, context),
          _buildTile('Service Providers', Icons.build, Colors.green, context),
          _buildTile('Complaints / Requests', Icons.report_problem, Colors.red, context),
        ],
      ),
    );
  }
}

