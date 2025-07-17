// lib/screens/admin/all_consumers_screen.dart
import 'package:flutter/material.dart';
import '../admin/user_details_screen.dart';

class Consumer {
  final String id;
  final String name;
  final String mobile;
  final String city;
  final String sector;
  final String houseType;
  final String building;
  final String pincode;

  Consumer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.city,
    required this.sector,
    required this.houseType,
    required this.building,
    required this.pincode,
  });

  String get fullAddress =>
      '$building, Sector $sector, $city, $pincode [$houseType]';
}

class AllConsumersScreen extends StatefulWidget {
  @override
  _AllConsumersScreenState createState() => _AllConsumersScreenState();
}

class _AllConsumersScreenState extends State<AllConsumersScreen> {
  List<Consumer> allConsumers = [
    Consumer(
      id: 'C001',
      name: 'Amit Sharma',
      mobile: '9876543210',
      city: 'Delhi',
      sector: '15',
      houseType: 'Apartment',
      building: 'Tower A',
      pincode: '110001',
    ),
    Consumer(
      id: 'C002',
      name: 'Priya Singh',
      mobile: '9123456789',
      city: 'Delhi',
      sector: '20',
      houseType: 'Villa',
      building: 'Green Villa',
      pincode: '110003',
    ),
    // Add more dummy consumers here
  ];

  // Filter values
  String? selectedCity;
  String? selectedSector;
  String? selectedHouseType;
  String? selectedBuilding;

  List<String> get distinctCities =>
      allConsumers.map((e) => e.city).toSet().toList();
  List<String> get distinctSectors =>
      allConsumers.map((e) => e.sector).toSet().toList();
  List<String> get distinctHouseTypes =>
      allConsumers.map((e) => e.houseType).toSet().toList();
  List<String> get distinctBuildings =>
      allConsumers.map((e) => e.building).toSet().toList();

  List<Consumer> get filteredConsumers {
    return allConsumers.where((consumer) {
      return (selectedCity == null || consumer.city == selectedCity) &&
          (selectedSector == null || consumer.sector == selectedSector) &&
          (selectedHouseType == null || consumer.houseType == selectedHouseType) &&
          (selectedBuilding == null || consumer.building == selectedBuilding);
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      selectedCity = null;
      selectedSector = null;
      selectedHouseType = null;
      selectedBuilding = null;
    });
  }

void _showConsumerDetails(BuildContext context, Consumer consumer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailsScreen(consumerId: consumer.id, name: consumer.name),
      ),
    );
  }

  Widget _buildFilter(String label, String? selectedValue, List<String> options,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(value: null, child: Text('All')),
        ...options.map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            )),
      ],
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Consumers'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _buildFilter('City', selectedCity, distinctCities,
                    (val) => setState(() => selectedCity = val)),
                _buildFilter('Sector', selectedSector, distinctSectors,
                    (val) => setState(() => selectedSector = val)),
                _buildFilter('House Type', selectedHouseType, distinctHouseTypes,
                    (val) => setState(() => selectedHouseType = val)),
                _buildFilter('Building', selectedBuilding, distinctBuildings,
                    (val) => setState(() => selectedBuilding = val)),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredConsumers.length,
                itemBuilder: (context, index) {
                  final consumer = filteredConsumers[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(child: Text(consumer.name[0])),
                      title: Text('${consumer.name} (${consumer.id})'),
                      subtitle: Text('${consumer.mobile}\n${consumer.fullAddress}'),
                      isThreeLine: true,
                      onTap: () => _showConsumerDetails(context, consumer),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}