// screens/dashboard/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../utils/theme_provider.dart';
import '../admin/all_consumers_screen.dart'; // Import this
import '../admin/all_service_providers_screen.dart';
import '../admin/all_complaints_requests_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const List<_AdminAction> _actions = [
    _AdminAction(
      title: 'All Consumers',
      subtitle: 'View and manage registered consumers',
      icon: Icons.group_outlined,
      color: Color(0xFF2563EB),
    ),
    _AdminAction(
      title: 'Service Providers',
      subtitle: 'Monitor providers and profiles',
      icon: Icons.handyman_outlined,
      color: Color(0xFF059669),
    ),
    _AdminAction(
      title: 'Complaints / Requests',
      subtitle: 'Review user complaints and support requests',
      icon: Icons.report_problem_outlined,
      color: Color(0xFFDC2626),
    ),
  ];

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AllComplaintsRequestsScreen()),
      );
    }
  }

  Widget _buildTile(_AdminAction action, BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onTileTap(context, action.title),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: action.color.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, color: action.color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  action.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  action.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        color: action.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, color: action.color, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth >= 850;
              final bool canUseTwoColumns = constraints.maxWidth >= 360;
              final int crossAxisCount = isWide ? 3 : (canUseTwoColumns ? 2 : 1);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Admin',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Choose a section below to manage users, providers, and requests quickly.',
                            style: TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _actions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isWide ? 1.35 : (canUseTwoColumns ? 1.2 : 1.45),
                      ),
                      itemBuilder: (context, index) => _buildTile(_actions[index], context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdminAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _AdminAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

