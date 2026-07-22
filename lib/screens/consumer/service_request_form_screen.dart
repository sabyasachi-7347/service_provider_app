import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/otp_dialog.dart';

class ServiceRequestFormScreen extends StatefulWidget {
  final String serviceName;

  /// Null when a guest (not logged in) is submitting a request — in that
  /// case a mobile-verified consumer record is created on submit instead.
  final String? consumerId;
  final String? consumerName;

  const ServiceRequestFormScreen({
    super.key,
    required this.serviceName,
    required this.consumerId,
    required this.consumerName,
  });

  @override
  State<ServiceRequestFormScreen> createState() =>
      _ServiceRequestFormScreenState();
}

class _ServiceRequestFormScreenState extends State<ServiceRequestFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  DateTime? _preferredDate;
  bool _isSubmitting = false;

  bool get _isGuest => widget.consumerId == null;

  @override
  void initState() {
    super.initState();
    if (!_isGuest) {
      _nameController.text = widget.consumerName ?? '';
      _prefillFromConsumerProfile();
    }
  }

  Future<void> _prefillFromConsumerProfile() async {
    try {
      final consumer = await ApiService.getConsumer(widget.consumerId!);
      if (!mounted) return;
      final address = consumer['address'] as Map<String, dynamic>?;
      setState(() {
        _mobileController.text = consumer['mobile']?.toString() ?? '';
        _cityController.text =
            address?['city']?.toString() ?? consumer['city']?.toString() ?? '';
        _sectorController.text =
            address?['sector']?.toString() ??
            consumer['sector']?.toString() ??
            '';
        _pincodeController.text =
            address?['pincode']?.toString() ??
            consumer['pincode']?.toString() ??
            '';
        _addressLineController.text =
            address?['buildingName']?.toString() ??
            consumer['building']?.toString() ??
            '';
        _landmarkController.text = address?['landmark']?.toString() ?? '';
      });
    } catch (_) {
      // No existing consumer profile to prefill from; user fills the form manually.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _mobileController.dispose();
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

  Map<String, dynamic> _addressPayload() {
    return {
      'buildingName': _addressLineController.text.trim(),
      'city': _cityController.text.trim(),
      'sector': _sectorController.text.trim(),
      'landmark': _landmarkController.text.trim(),
      'pincode': _pincodeController.text.trim(),
    };
  }

  Future<void> _submitRequest() async {
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

    if (_isGuest) {
      // New visitor: verify their mobile number via OTP before we create a
      // consumer record and file the request under it.
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => OtpDialog(
              mobile: _mobileController.text.trim(),
              onVerified: _createConsumerAndSubmitRequest,
            ),
      );
      return;
    }

    await _createServiceRequest(
      consumerId: widget.consumerId!,
      consumerName: widget.consumerName!,
    );
  }

  Future<void> _createConsumerAndSubmitRequest() async {
    if (!mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final consumer = await ApiService.createConsumer({
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'address': _addressPayload(),
      });
      final consumerId = consumer['id']?.toString() ?? '';

      await _createServiceRequest(
        consumerId: consumerId,
        consumerName: _nameController.text.trim(),
        successMessage:
            'Request submitted for ${widget.serviceName}. Your consumer ID is $consumerId — keep it for future reference.',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register your details: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _createServiceRequest({
    required String consumerId,
    required String consumerName,
    String? successMessage,
  }) async {
    setState(() => _isSubmitting = true);

    try {
      await ApiService.createRequest({
        'consumerId': consumerId,
        'consumerName': consumerName,
        'mobile': _mobileController.text.trim(),
        'category': widget.serviceName,
        'description':
            '${_issueTitleController.text.trim()}: ${_descriptionController.text.trim()}',
        'preferredDate': _preferredDate!.toIso8601String(),
        'address': _addressPayload(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successMessage ?? 'Request submitted for ${widget.serviceName}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
                if (_isGuest) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      'Full name',
                      icon: Icons.person_outline,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => _requiredValidator(value, 'Name'),
                  ),
                  const SizedBox(height: 10),
                ],
                TextFormField(
                  controller: _issueTitleController,
                  decoration: _inputDecoration(
                    'Issue title',
                    icon: Icons.title_outlined,
                  ),
                  validator:
                      (value) => _requiredValidator(value, 'Issue title'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 4,
                  decoration: _inputDecoration(
                    'Problem description',
                    icon: Icons.description_outlined,
                  ),
                  validator:
                      (value) =>
                          _requiredValidator(value, 'Problem description'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    'Contact mobile number',
                    icon: Icons.phone_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (value.trim().length < 10) {
                      return 'Enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickPreferredDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: _inputDecoration(
                      'Preferred service date',
                      icon: Icons.event_outlined,
                    ),
                    child: Text(
                      _preferredDate == null
                          ? 'Select date'
                          : _formatDate(_preferredDate!),
                      style: TextStyle(
                        color:
                            _preferredDate == null
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
                  decoration: _inputDecoration(
                    'House / Flat / Building',
                    icon: Icons.home_outlined,
                  ),
                  validator: (value) => _requiredValidator(value, 'Address'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cityController,
                  decoration: _inputDecoration(
                    'City',
                    icon: Icons.location_city_outlined,
                  ),
                  validator: (value) => _requiredValidator(value, 'City'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sectorController,
                  decoration: _inputDecoration(
                    'Sector / Area',
                    icon: Icons.map_outlined,
                  ),
                  validator:
                      (value) => _requiredValidator(value, 'Sector / Area'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _landmarkController,
                  decoration: _inputDecoration(
                    'Landmark',
                    icon: Icons.place_outlined,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    'Pincode',
                    icon: Icons.pin_outlined,
                  ),
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
                    onPressed: _isSubmitting ? null : _submitRequest,
                    icon:
                        _isSubmitting
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.send_rounded),
                    label: Text(
                      _isSubmitting ? 'Submitting...' : 'Submit Request',
                    ),
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
