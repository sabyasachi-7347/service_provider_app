// lib/screens/admin/all_consumers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/api_service.dart';
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
  final bool isAmcActive;

  Consumer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.city,
    required this.sector,
    required this.houseType,
    required this.building,
    required this.pincode,
    required this.isAmcActive,
  });

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      sector: json['sector']?.toString() ?? '',
      houseType: json['houseType']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      isAmcActive: json['isAmcActive'] == true,
    );
  }

  String get fullAddress =>
      '$building, Sector $sector, $city, $pincode [$houseType]';
}

/// Result returned when the add-consumer sheet saves successfully.
class AddConsumerSheetResult {
  final String name;
  final String mobile;
  final String houseType;
  final bool isAmcActive;
  final String flatNo;
  final String floor;
  final String area;
  final String plot;
  final String landmark;
  final String buildingName;
  final String city;
  final String sector;
  final String pincode;

  AddConsumerSheetResult({
    required this.name,
    required this.mobile,
    required this.houseType,
    required this.isAmcActive,
    required this.flatNo,
    required this.floor,
    required this.area,
    required this.plot,
    required this.landmark,
    required this.buildingName,
    required this.city,
    required this.sector,
    required this.pincode,
  });
}

/// Bottom sheet content: owns [Form] key and text controllers so they are
/// disposed after the route is torn down (avoids framework assertion on pop).
class _AddConsumerSheet extends StatefulWidget {
  const _AddConsumerSheet();

  @override
  State<_AddConsumerSheet> createState() => _AddConsumerSheetState();
}

class _AddConsumerSheetState extends State<_AddConsumerSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _houseTypeCtrl = TextEditingController();
  final TextEditingController _flatCtrl = TextEditingController();
  final TextEditingController _floorCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _plotCtrl = TextEditingController();
  final TextEditingController _landmarkCtrl = TextEditingController();
  final TextEditingController _buildingCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _sectorCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController();
  bool _isAmcActive = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _houseTypeCtrl.dispose();
    _flatCtrl.dispose();
    _floorCtrl.dispose();
    _areaCtrl.dispose();
    _plotCtrl.dispose();
    _landmarkCtrl.dispose();
    _buildingCtrl.dispose();
    _cityCtrl.dispose();
    _sectorCtrl.dispose();
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
      AddConsumerSheetResult(
        name: _nameCtrl.text.trim(),
        mobile: _phoneCtrl.text.trim(),
        houseType: _houseTypeCtrl.text.trim(),
        isAmcActive: _isAmcActive,
        flatNo: _flatCtrl.text.trim(),
        floor: _floorCtrl.text.trim(),
        area: _areaCtrl.text.trim(),
        plot: _plotCtrl.text.trim(),
        landmark: _landmarkCtrl.text.trim(),
        buildingName: _buildingCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        sector: _sectorCtrl.text.trim(),
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
                'Add Consumer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: _fieldDecoration('Name'),
                textCapitalization: TextCapitalization.words,
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter name' : null,
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _houseTypeCtrl,
                decoration: _fieldDecoration('House type (e.g. Apartment)'),
                textCapitalization: TextCapitalization.words,
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Enter house type'
                            : null,
              ),
              const SizedBox(height: 6),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('AMC Active'),
                value: _isAmcActive,
                onChanged: (v) => setState(() => _isAmcActive = v),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Address',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _flatCtrl,
                decoration: _fieldDecoration('Flat / House No'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _buildingCtrl,
                decoration: _fieldDecoration('Building name'),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Enter building name'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _floorCtrl,
                decoration: _fieldDecoration('Floor'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _areaCtrl,
                decoration: _fieldDecoration('Area'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _plotCtrl,
                decoration: _fieldDecoration('Plot'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _landmarkCtrl,
                decoration: _fieldDecoration('Landmark'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityCtrl,
                decoration: _fieldDecoration('City'),
                textCapitalization: TextCapitalization.words,
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter city' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sectorCtrl,
                decoration: _fieldDecoration('Sector'),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Enter sector'
                            : null,
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

class AllConsumersScreen extends StatefulWidget {
  const AllConsumersScreen({super.key});

  @override
  _AllConsumersScreenState createState() => _AllConsumersScreenState();
}

class _AllConsumersScreenState extends State<AllConsumersScreen> {
  List<Consumer> allConsumers = [];
  bool _isLoading = true;
  String? _errorMessage;

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

  @override
  void initState() {
    super.initState();
    _loadConsumers();
  }

  Future<void> _loadConsumers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getConsumers();
      if (!mounted) return;
      setState(() {
        allConsumers =
            data
                .map((item) => Consumer.fromJson(item as Map<String, dynamic>))
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Consumer> get filteredConsumers {
    return allConsumers.where((consumer) {
      return (selectedCity == null || consumer.city == selectedCity) &&
          (selectedSector == null || consumer.sector == selectedSector) &&
          (selectedHouseType == null ||
              consumer.houseType == selectedHouseType) &&
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

  Future<void> _openAddConsumerForm() async {
    final AddConsumerSheetResult? result =
        await showModalBottomSheet<AddConsumerSheetResult>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => const _AddConsumerSheet(),
        );

    if (!mounted || result == null) return;

    try {
      final created = await ApiService.createConsumer({
        'name': result.name,
        'mobile': result.mobile,
        'houseType': result.houseType,
        'isAmcActive': result.isAmcActive,
        'address': {
          'flatNo': result.flatNo,
          'floor': result.floor,
          'area': result.area,
          'plot': result.plot,
          'landmark': result.landmark,
          'buildingName': result.buildingName,
          'city': result.city,
          'sector': result.sector,
          'pincode': result.pincode,
        },
      });

      if (!mounted) return;
      final consumer = Consumer.fromJson(created);
      setState(() {
        allConsumers = [...allConsumers, consumer];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consumer added (${consumer.id})')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add consumer: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showConsumerDetails(BuildContext context, Consumer consumer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => UserDetailsScreen(
              consumerId: consumer.id,
              name: consumer.name,
              isAmcActive: consumer.isAmcActive,
            ),
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
        const DropdownMenuItem<String>(value: null, child: Text('All')),
        ...options.map(
          (value) => DropdownMenuItem<String>(value: value, child: Text(value)),
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
                      consumer.name.isNotEmpty ? consumer.name[0] : '?',
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
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.call_outlined,
                    size: 16,
                    color: Color(0xFF4B5563),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
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
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Color(0xFF4B5563),
                  ),
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadConsumers,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: _openAddConsumerForm,
            tooltip: 'Add consumer',
          ),
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
                    const Icon(
                      Icons.filter_list_rounded,
                      color: Color(0xFF1F2937),
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Failed to load consumers: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFDC2626)),
                        ),
                      ),
                    )
                    : filteredConsumers.isEmpty
                    ? const Center(
                      child: Text(
                        'No customers match your filters.',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      itemCount: filteredConsumers.length,
                      itemBuilder:
                          (context, index) =>
                              _buildConsumerCard(filteredConsumers[index]),
                    ),
          ),
        ],
      ),
    );
  }
}
