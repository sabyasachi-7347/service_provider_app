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
  const AllConsumersScreen({super.key});

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

  int get _activeFilterCount {
    int count = 0;
    if (selectedCity != null) count++;
    if (selectedSector != null) count++;
    if (selectedHouseType != null) count++;
    if (selectedBuilding != null) count++;
    return count;
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
        builder: (_) =>
            UserDetailsScreen(consumerId: consumer.id, name: consumer.name),
      ),
    );
  }

  Widget _buildFilter(
    String label,
    String? selectedValue,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All'),
        ),
        ...options.map(
          (value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildConsumerCard(Consumer consumer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showConsumerDetails(context, consumer),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFDBEAFE),
                    child: Text(
                      consumer.name[0],
                      style: const TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consumer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${consumer.id}',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.call_outlined, size: 16, color: Color(0xFF4B5563)),
                  const SizedBox(width: 6),
                  Text(
                    consumer.mobile,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      consumer.houseType,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF4B5563)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      consumer.fullAddress,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
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
        title: const Text('All Consumers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.filter_list_rounded, color: Color(0xFF1F2937)),
                    const SizedBox(width: 8),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if (_activeFilterCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$_activeFilterCount active',
                          style: const TextStyle(
                            color: Color(0xFF1D4ED8),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilter(
                        'City',
                        selectedCity,
                        distinctCities,
                        (val) => setState(() => selectedCity = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFilter(
                        'Sector',
                        selectedSector,
                        distinctSectors,
                        (val) => setState(() => selectedSector = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilter(
                        'House Type',
                        selectedHouseType,
                        distinctHouseTypes,
                        (val) => setState(() => selectedHouseType = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFilter(
                        'Building',
                        selectedBuilding,
                        distinctBuildings,
                        (val) => setState(() => selectedBuilding = val),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(
              children: [
                Text(
                  '${filteredConsumers.length} customers found',
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredConsumers.isEmpty
                ? const Center(
                    child: Text(
                      'No customers match your filters.',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: filteredConsumers.length,
                    itemBuilder: (context, index) =>
                        _buildConsumerCard(filteredConsumers[index]),
                  ),
          ),
        ],
      ),
    );
  }
}