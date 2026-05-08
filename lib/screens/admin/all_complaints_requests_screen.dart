// lib/screens/admin/all_complaints_requests_screen.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

// import "../admin/user_details_screen.dart";
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

  factory ComplaintRequest.fromJson(Map<String, dynamic> json) {
    return ComplaintRequest(
      id: json['id']?.toString() ?? '',
      consumerName: json['consumerName']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'Open',
    );
  }
}

class AllComplaintsRequestsScreen extends StatelessWidget {
  const AllComplaintsRequestsScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFFDC2626);
      case 'In Progress':
        return const Color(0xFFD97706);
      case 'Closed':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AllComplaintsRequestsView(getStatusColor: getStatusColor);
  }
}

class _AllComplaintsRequestsView extends StatefulWidget {
  final Color Function(String status) getStatusColor;

  const _AllComplaintsRequestsView({required this.getStatusColor});

  @override
  State<_AllComplaintsRequestsView> createState() =>
      _AllComplaintsRequestsViewState();
}

class _AllComplaintsRequestsViewState
    extends State<_AllComplaintsRequestsView> {
  final TextEditingController _searchController = TextEditingController();
  List<ComplaintRequest> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? selectedStatus;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get distinctStatuses =>
      _requests.map((e) => e.status).toSet().toList()..sort();
  List<String> get distinctCategories =>
      _requests.map((e) => e.category).toSet().toList()..sort();

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getRequests();
      if (!mounted) return;
      setState(() {
        _requests =
            data
                .map(
                  (item) =>
                      ComplaintRequest.fromJson(item as Map<String, dynamic>),
                )
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

  List<ComplaintRequest> get filteredRequests {
    final query = _searchController.text.trim().toLowerCase();
    return _requests.where((item) {
      final matchesQuery =
          query.isEmpty ||
          item.id.toLowerCase().contains(query) ||
          item.consumerName.toLowerCase().contains(query) ||
          item.mobile.contains(query) ||
          item.description.toLowerCase().contains(query);

      return matchesQuery &&
          (selectedStatus == null || item.status == selectedStatus) &&
          (selectedCategory == null || item.category == selectedCategory);
    }).toList();
  }

  int get _activeFilterCount {
    int count = 0;
    if (_searchController.text.trim().isNotEmpty) count++;
    if (selectedStatus != null) count++;
    if (selectedCategory != null) count++;
    return count;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      selectedStatus = null;
      selectedCategory = null;
    });
  }

  String _formatDate(DateTime date) {
    final DateTime d = date.toLocal();
    final String month = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('All')),
        ...options.map(
          (item) => DropdownMenuItem(value: item, child: Text(item)),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildRequestCard(ComplaintRequest item) {
    final Color statusColor = widget.getStatusColor(item.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.consumerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Request ID: ${item.id}',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(item.status),
                  backgroundColor: statusColor.withOpacity(0.12),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.call_outlined,
                  size: 16,
                  color: Color(0xFF4B5563),
                ),
                const SizedBox(width: 6),
                Text(
                  item.mobile,
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
                const Spacer(),
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
                    item.category,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(color: Color(0xFF374151), height: 1.35),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(item.date),
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12.5,
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
        title: const Text('Complaints & Requests'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
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
                    const Icon(Icons.tune_rounded, color: Color(0xFF1F2937)),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter Requests',
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
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name, ID, mobile, or description',
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
                        label: 'Status',
                        value: selectedStatus,
                        options: distinctStatuses,
                        onChanged:
                            (val) => setState(() => selectedStatus = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Category',
                        value: selectedCategory,
                        options: distinctCategories,
                        onChanged:
                            (val) => setState(() => selectedCategory = val),
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
                  '${filteredRequests.length} records found',
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
                          'Failed to load requests: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFDC2626)),
                        ),
                      ),
                    )
                    : filteredRequests.isEmpty
                    ? const Center(
                      child: Text(
                        'No complaints or requests match current filters.',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      itemCount: filteredRequests.length,
                      itemBuilder:
                          (context, index) =>
                              _buildRequestCard(filteredRequests[index]),
                    ),
          ),
        ],
      ),
    );
  }
}
