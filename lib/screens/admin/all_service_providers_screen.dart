// lib/screens/admin/all_service_providers_screen.dart
import 'package:flutter/material.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String mobile;
  final String city;
  final String sector;
  final String houseType;
  final String building;
  final String pincode;
  final String category;
  final double rating;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.mobile,
    required this.city,
    required this.sector,
    required this.houseType,
    required this.building,
    required this.pincode,
    required this.category,
    required this.rating,
  });

  String get fullAddress =>
      '$building, Sector $sector, $city, $pincode [$houseType]';
}

class AllServiceProvidersScreen extends StatelessWidget {
  final List<ServiceProvider> serviceProviders = [
    ServiceProvider(
      id: 'SP001',
      name: 'Raj Electrician',
      mobile: '9876543210',
      city: 'Delhi',
      sector: '5',
      houseType: 'Shop',
      building: 'Block B',
      pincode: '110005',
      category: 'Electrician',
      rating: 4.5,
    ),
    ServiceProvider(
      id: 'SP002',
      name: 'Neha Plumber',
      mobile: '9123456789',
      city: 'Gurgaon',
      sector: '23',
      houseType: 'Workshop',
      building: 'Service Plaza',
      pincode: '122001',
      category: 'Plumber',
      rating: 4.2,
    ),
    // Add more dummy service providers here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Service Providers')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (context, index) {
            final sp = serviceProviders[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(sp.name[0]),
                  backgroundColor: Colors.blueAccent,
                ),
                title: Text('${sp.name} (${sp.id})'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile: ${sp.mobile}'),
                    Text('Address: ${sp.fullAddress}'),
                    Text('Category: ${sp.category}'),
                    Row(
                      children: [
                        Text('Rating: ${sp.rating}'),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}