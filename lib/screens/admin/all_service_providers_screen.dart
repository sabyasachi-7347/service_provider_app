// lib/screens/admin/all_service_providers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String mobile;
  /// Service offering (e.g. Electrician) — used for filters as "category".
  final String serviceType;
  final String fullAddressLine;
  final String city;
  final String state;
  final String pincode;
  final String businessType;
  final double rating;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.mobile,
    required this.serviceType,
    required this.fullAddressLine,
    required this.city,
    required this.state,
    required this.pincode,
    required this.businessType,
    required this.rating,
  });

  /// Alias for filter dropdowns that still use "category".
  String get category => serviceType;

  String get fullAddress =>
      '$fullAddressLine, $city, $state $pincode · $businessType';
}

/// Result returned when the add-provider sheet saves successfully.
class AddProviderSheetResult {
  final String name;
  final String mobile;
  final String serviceType;
  final String businessType;
  final String fullAddressLine;
  final String city;
  final String state;
  final String pincode;

  AddProviderSheetResult({
    required this.name,
    required this.mobile,
    required this.serviceType,
    required this.businessType,
    required this.fullAddressLine,
    required this.city,
    required this.state,
    required this.pincode,
  });
}

/// Bottom sheet content: owns [Form] key and text controllers so they are
/// disposed after the route is torn down (avoids framework assertion on pop).
class _AddServiceProviderSheet extends StatefulWidget {
  final List<String> serviceTypes;
  final List<String> businessTypes;

  const _AddServiceProviderSheet({
    required this.serviceTypes,
    required this.businessTypes,
  });

  @override
  State<_AddServiceProviderSheet> createState() => _AddServiceProviderSheetState();
}

class _AddServiceProviderSheetState extends State<_AddServiceProviderSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl = TextEditingController();
  late final TextEditingController _phoneCtrl = TextEditingController();
  late final TextEditingController _addressCtrl = TextEditingController();
  late final TextEditingController _cityCtrl = TextEditingController();
  late final TextEditingController _stateCtrl = TextEditingController();
  late final TextEditingController _pinCtrl = TextEditingController();

  late String _serviceType;
  late String _businessType;

  @override
  void initState() {
    super.initState();
    _serviceType = widget.serviceTypes.first;
    _businessType = widget.businessTypes.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  static InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      AddProviderSheetResult(
        name: _nameCtrl.text.trim(),
        mobile: _phoneCtrl.text.trim(),
        serviceType: _serviceType,
        businessType: _businessType,
        fullAddressLine: _addressCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        pincode: _pinCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: bottomInset + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Service Provider',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: _fieldDecoration('Name'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _serviceType,
                decoration: _fieldDecoration('Service type'),
                items: widget.serviceTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _serviceType = v);
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _businessType,
                decoration: _fieldDecoration('Type of business'),
                items: widget.businessTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _businessType = v);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneCtrl,
                decoration: _fieldDecoration('Phone number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                validator: (v) {
                  if (v == null || v.trim().length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Address',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                decoration: _fieldDecoration('Full address'),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter full address' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityCtrl,
                decoration: _fieldDecoration('City'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter city' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stateCtrl,
                decoration: _fieldDecoration('State'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter state' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pinCtrl,
                decoration: _fieldDecoration('PIN code'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (v) {
                  if (v == null || v.trim().length != 6) {
                    return 'Enter a valid 6-digit PIN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Save'),
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
}

class AllServiceProvidersScreen extends StatefulWidget {
  const AllServiceProvidersScreen({super.key});

  @override
  State<AllServiceProvidersScreen> createState() =>
      _AllServiceProvidersScreenState();
}

class _AllServiceProvidersScreenState extends State<AllServiceProvidersScreen> {
  late List<ServiceProvider> _serviceProviders;

  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedCategory;
  double _selectedMinRating = 0;

  static const List<String> _serviceTypes = [
    'Electrician',
    'Plumber',
    'AC Service',
    'Appliance Repair',
    'Carpenter',
    'Cleaning',
    'Maintenance',
    'Other',
  ];

  static const List<String> _businessTypes = [
    'Individual',
    'Shop',
    'Workshop',
    'Company',
    'Franchise',
    'Partnership',
  ];

  @override
  void initState() {
    super.initState();
    _serviceProviders = [
      ServiceProvider(
        id: 'SP001',
        name: 'Raj Electrician',
        mobile: '9876543210',
        fullAddressLine: 'Block B, Shop 12',
        city: 'Delhi',
        state: 'Delhi',
        pincode: '110005',
        serviceType: 'Electrician',
        businessType: 'Shop',
        rating: 4.5,
      ),
      ServiceProvider(
        id: 'SP002',
        name: 'Neha Plumber',
        mobile: '9123456789',
        fullAddressLine: 'Service Plaza, Unit 4',
        city: 'Gurgaon',
        state: 'Haryana',
        pincode: '122001',
        serviceType: 'Plumber',
        businessType: 'Workshop',
        rating: 4.2,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _distinctCities =>
      _serviceProviders.map((e) => e.city).toSet().toList()..sort();

  List<String> get _distinctCategories =>
      _serviceProviders.map((e) => e.category).toSet().toList()..sort();

  List<ServiceProvider> get _filteredProviders {
    final query = _searchController.text.trim().toLowerCase();
    return _serviceProviders.where((sp) {
      final searchMatches = query.isEmpty ||
          sp.name.toLowerCase().contains(query) ||
          sp.id.toLowerCase().contains(query) ||
          sp.mobile.contains(query);

      return searchMatches &&
          (_selectedCity == null || sp.city == _selectedCity) &&
          (_selectedCategory == null || sp.category == _selectedCategory) &&
          sp.rating >= _selectedMinRating;
    }).toList();
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedCity != null) count++;
    if (_selectedCategory != null) count++;
    if (_selectedMinRating > 0) count++;
    if (_searchController.text.trim().isNotEmpty) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _selectedCity = null;
      _selectedCategory = null;
      _selectedMinRating = 0;
      _searchController.clear();
    });
  }

  int _nextIdNumber() {
    int maxNum = 0;
    for (final sp in _serviceProviders) {
      final match = RegExp(r'^SP(\d+)$').firstMatch(sp.id);
      if (match != null) {
        final n = int.tryParse(match.group(1) ?? '0') ?? 0;
        if (n > maxNum) maxNum = n;
      }
    }
    return maxNum + 1;
  }

  Future<void> _openAddProviderForm() async {
    final AddProviderSheetResult? result =
        await showModalBottomSheet<AddProviderSheetResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _AddServiceProviderSheet(
        serviceTypes: _serviceTypes,
        businessTypes: _businessTypes,
      ),
    );

    if (!mounted || result == null) return;

    final id = 'SP${_nextIdNumber().toString().padLeft(3, '0')}';
    setState(() {
      _serviceProviders = [
        ..._serviceProviders,
        ServiceProvider(
          id: id,
          name: result.name,
          mobile: result.mobile,
          serviceType: result.serviceType,
          fullAddressLine: result.fullAddressLine,
          city: result.city,
          state: result.state,
          pincode: result.pincode,
          businessType: result.businessType,
          rating: 0,
        ),
      ];
      _selectedMinRating = 0;
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Provider added ($id)')),
    );
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
                    sp.name.isNotEmpty ? sp.name[0].toUpperCase() : '?',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                    const SizedBox(height: 4),
                    Text(
                      sp.businessType,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
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
                  sp.rating > 0 ? sp.rating.toStringAsFixed(1) : '—',
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
            tooltip: 'Add provider',
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: _openAddProviderForm,
          ),
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
                        value: _selectedCity,
                        options: _distinctCities,
                        onChanged: (val) => setState(() => _selectedCity = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Category',
                        value: _selectedCategory,
                        options: _distinctCategories,
                        onChanged: (val) => setState(() => _selectedCategory = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum Rating: ${_selectedMinRating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                Slider(
                  value: _selectedMinRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _selectedMinRating.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _selectedMinRating = value),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(
              children: [
                Text(
                  '${_filteredProviders.length} providers found',
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredProviders.isEmpty
                ? const Center(
                    child: Text(
                      'No providers match current filters.',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: _filteredProviders.length,
                    itemBuilder: (context, index) =>
                        _buildProviderCard(_filteredProviders[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
