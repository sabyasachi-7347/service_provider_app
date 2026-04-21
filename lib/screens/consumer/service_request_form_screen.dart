import 'package:flutter/material.dart';

class ServiceRequestFormScreen extends StatefulWidget {
  final String serviceName;

  const ServiceRequestFormScreen({super.key, required this.serviceName});

  @override
  State<ServiceRequestFormScreen> createState() => _ServiceRequestFormScreenState();
}

class _ServiceRequestFormScreenState extends State<ServiceRequestFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  DateTime? _preferredDate;

  @override
  void dispose() {
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _sectorController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _pickPreferredDate() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: _preferredDate ?? now,
    );
    if (selected != null) {
      setState(() {
        _preferredDate = selected;
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  void _submitRequest() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_preferredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a preferred service date'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for ${widget.serviceName}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Request Form')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    'Requesting: ${widget.serviceName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3730A3),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _issueTitleController,
                  decoration: _inputDecoration('Issue title', icon: Icons.title_outlined),
                  validator: (value) => _requiredValidator(value, 'Issue title'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 4,
                  decoration:
                      _inputDecoration('Problem description', icon: Icons.description_outlined),
                  validator: (value) => _requiredValidator(value, 'Problem description'),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickPreferredDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: _inputDecoration('Preferred service date', icon: Icons.event_outlined),
                    child: Text(
                      _preferredDate == null
                          ? 'Select date'
                          : _formatDate(_preferredDate!),
                      style: TextStyle(
                        color: _preferredDate == null
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Service Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressLineController,
                  decoration: _inputDecoration('House / Flat / Building', icon: Icons.home_outlined),
                  validator: (value) => _requiredValidator(value, 'Address'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cityController,
                  decoration: _inputDecoration('City', icon: Icons.location_city_outlined),
                  validator: (value) => _requiredValidator(value, 'City'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sectorController,
                  decoration: _inputDecoration('Sector / Area', icon: Icons.map_outlined),
                  validator: (value) => _requiredValidator(value, 'Sector / Area'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _landmarkController,
                  decoration: _inputDecoration('Landmark', icon: Icons.place_outlined),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Pincode', icon: Icons.pin_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Pincode is required';
                    }
                    if (value.trim().length < 6) {
                      return 'Enter a valid pincode';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _submitRequest,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Submit Request'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
