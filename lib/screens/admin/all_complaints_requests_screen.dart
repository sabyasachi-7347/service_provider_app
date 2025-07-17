// lib/screens/admin/all_complaints_requests_screen.dart
import 'package:flutter/material.dart';
import "../admin/user_details_screen.dart";
class ComplaintRequest {
  final String id;
  final String consumerName;
  final String mobile;
  final String category;
  final String description;
  final DateTime date;
  final String status;

  ComplaintRequest({
    required this.id,
    required this.consumerName,
    required this.mobile,
    required this.category,
    required this.description,
    required this.date,
    required this.status,
  });
}

class AllComplaintsRequestsScreen extends StatelessWidget {
  final List<ComplaintRequest> requests = [
    ComplaintRequest(
      id: 'CR001',
      consumerName: 'Amit Sharma',
      mobile: '9876543210',
      category: 'Electricity',
      description: 'Frequent power cuts.',
      date: DateTime(2025, 7, 12),
      status: 'Open',
    ),
    ComplaintRequest(
      id: 'CR002',
      consumerName: 'Priya Singh',
      mobile: '9123456789',
      category: 'Water Supply',
      description: 'Low water pressure in the morning.',
      date: DateTime(2025, 7, 10),
      status: 'In Progress',
    ),
    ComplaintRequest(
      id: 'CR003',
      consumerName: 'Ravi Patel',
      mobile: '9988776655',
      category: 'Maintenance',
      description: 'Street light not working.',
      date: DateTime(2025, 7, 8),
      status: 'Closed',
    ),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complaints & Requests')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final item = requests[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text('${item.consumerName} (${item.id})'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile: ${item.mobile}'),
                    Text('Category: ${item.category}'),
                    Text('Description: ${item.description}'),
                    Text('Date: ${item.date.toLocal().toString().split(' ')[0]}'),
                  ],
                ),
                trailing: Chip(
                  label: Text(item.status),
                  backgroundColor: getStatusColor(item.status).withOpacity(0.2),
                  labelStyle: TextStyle(color: getStatusColor(item.status)),
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