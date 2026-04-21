import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../consumer/service_request_form_screen.dart';

class ConsumerDashboard extends StatelessWidget {
  const ConsumerDashboard({super.key});

  static const List<_ServiceOption> _serviceOptions = [
    _ServiceOption(
      title: 'Electrician',
      subtitle: 'Wiring, switch and power issues',
      icon: Icons.electrical_services_outlined,
      color: Color(0xFF2563EB),
    ),
    _ServiceOption(
      title: 'Plumber',
      subtitle: 'Leakage, blockage and pipe fixes',
      icon: Icons.plumbing_outlined,
      color: Color(0xFF0891B2),
    ),
    _ServiceOption(
      title: 'AC Service',
      subtitle: 'Cooling, gas refill and servicing',
      icon: Icons.ac_unit_outlined,
      color: Color(0xFF7C3AED),
    ),
    _ServiceOption(
      title: 'Appliance Repair',
      subtitle: 'Fridge, washing machine, microwave',
      icon: Icons.home_repair_service_outlined,
      color: Color(0xFFEA580C),
    ),
    _ServiceOption(
      title: 'Carpenter',
      subtitle: 'Furniture repair and fitting',
      icon: Icons.handyman_outlined,
      color: Color(0xFF059669),
    ),
    _ServiceOption(
      title: 'Cleaning',
      subtitle: 'Deep cleaning and sanitization',
      icon: Icons.cleaning_services_outlined,
      color: Color(0xFFDB2777),
    ),
  ];

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _requestService(BuildContext context, _ServiceOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceRequestFormScreen(serviceName: option.title),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceOption option) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _requestService(context, option),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: option.color.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(option.icon, color: option.color),
                ),
                const SizedBox(height: 10),
                Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Request',
                      style: TextStyle(
                        color: option.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, color: option.color, size: 18),
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
        title: const Text('Consumer Home'),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;
            final bool isTablet = constraints.maxWidth >= 600;
            final int crossAxisCount = isWide ? 3 : (isTablet ? 2 : 2);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3730A3),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose a service and place a request in one tap.',
                          style: TextStyle(color: Color(0xFF4338CA)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Service Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _serviceOptions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: isTablet ? 1.15 : 0.96,
                    ),
                    itemBuilder: (context, index) =>
                        _buildServiceCard(context, _serviceOptions[index]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ServiceOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ServiceOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
