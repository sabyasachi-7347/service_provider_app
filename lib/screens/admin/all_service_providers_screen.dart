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
  AllServiceProvidersScreen({super.key});

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
    return _AllServiceProvidersView(serviceProviders: serviceProviders);
  }
}

class _AllServiceProvidersView extends StatefulWidget {
  final List<ServiceProvider> serviceProviders;

  const _AllServiceProvidersView({required this.serviceProviders});

  @override
  State<_AllServiceProvidersView> createState() => _AllServiceProvidersViewState();
}

class _AllServiceProvidersViewState extends State<_AllServiceProvidersView> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCity;
  String? selectedCategory;
  double selectedMinRating = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get distinctCities =>
      widget.serviceProviders.map((e) => e.city).toSet().toList()..sort();

  List<String> get distinctCategories =>
      widget.serviceProviders.map((e) => e.category).toSet().toList()..sort();

  List<ServiceProvider> get filteredProviders {
    final query = _searchController.text.trim().toLowerCase();
    return widget.serviceProviders.where((sp) {
      final searchMatches = query.isEmpty ||
          sp.name.toLowerCase().contains(query) ||
          sp.id.toLowerCase().contains(query) ||
          sp.mobile.contains(query);

      return searchMatches &&
          (selectedCity == null || sp.city == selectedCity) &&
          (selectedCategory == null || sp.category == selectedCategory) &&
          sp.rating >= selectedMinRating;
    }).toList();
  }

  int get _activeFilterCount {
    int count = 0;
    if (selectedCity != null) count++;
    if (selectedCategory != null) count++;
    if (selectedMinRating > 0) count++;
    if (_searchController.text.trim().isNotEmpty) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      selectedCity = null;
      selectedCategory = null;
      selectedMinRating = 0;
      _searchController.clear();
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
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
        const DropdownMenuItem<String>(value: null, child: Text('All')),
        ...options.map((item) => DropdownMenuItem(value: item, child: Text(item))),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildProviderCard(ServiceProvider sp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(
                    sp.name[0],
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
                        sp.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${sp.id}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    sp.category,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.call_outlined, size: 16, color: Color(0xFF4B5563)),
                const SizedBox(width: 6),
                Text(
                  sp.mobile,
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
                const Spacer(),
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  sp.rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                    sp.fullAddress,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Providers'),
        actions: [
          IconButton(
            tooltip: 'Clear filters',
            icon: const Icon(Icons.clear_all),
            onPressed: _clearFilters,
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
                      'Find Providers',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    if (_activeFilterCount > 0)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name, ID, or mobile',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'City',
                        value: selectedCity,
                        options: distinctCities,
                        onChanged: (val) => setState(() => selectedCity = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Category',
                        value: selectedCategory,
                        options: distinctCategories,
                        onChanged: (val) => setState(() => selectedCategory = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum Rating: ${selectedMinRating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                Slider(
                  value: selectedMinRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: selectedMinRating.toStringAsFixed(1),
                  onChanged: (value) => setState(() => selectedMinRating = value),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(
              children: [
                Text(
                  '${filteredProviders.length} providers found',
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProviders.isEmpty
                ? const Center(
                    child: Text(
                      'No providers match current filters.',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: filteredProviders.length,
                    itemBuilder: (context, index) =>
                        _buildProviderCard(filteredProviders[index]),
                  ),
          ),
        ],
      ),
    );
  }
}