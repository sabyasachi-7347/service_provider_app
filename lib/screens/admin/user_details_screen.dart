// lib/screens/admin/user_details_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserDetailsScreen extends StatefulWidget {
  final String consumerId;
  final String name;

  const UserDetailsScreen({required this.consumerId, required this.name});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _nameController = TextEditingController();
  final _flatController = TextEditingController();
  final _sectorController = TextEditingController();
  final _floorController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _areaController = TextEditingController();
  final _plotController = TextEditingController();
  final _cityController = TextEditingController();
  final _buildingController = TextEditingController();
  final _pincodeController = TextEditingController();

  List<Map<String, dynamic>> assets = [];
  List<Map<String, dynamic>> familyMembers = [];
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  Future<void> _pickBillFile() async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera); // or ImageSource.gallery
    // Save/display the file
  }

  void _addAsset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Asset"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your asset form here
            Text("Asset adding form goes here"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: Text("Save")),
        ],
      ),
    );
  }

  void _addFamilyMember() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Family Member"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add family member form here
            Text("Family member form goes here"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: Text("Save")),
        ],
      ),
    );
  }

  void _addVehicle() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Vehicle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add vehicle form here
            Text("Vehicle adding form goes here"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: Text("Save")),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Consumer ID: ${widget.consumerId}", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("Name", _nameController),
            Divider(),
            Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField("Flat No", _flatController),
            _buildTextField("Sector No", _sectorController),
            _buildTextField("Floor", _floorController),
            _buildTextField("Landmark", _landmarkController),
            _buildTextField("Area", _areaController),
            _buildTextField("Plot", _plotController),
            _buildTextField("City", _cityController),
            _buildTextField("Building Name", _buildingController),
            _buildTextField("Pincode", _pincodeController),

            SizedBox(height: 20),
            ExpansionTile(
              title: Text("Assets"),
              children: [
                for (var asset in assets)
                  ListTile(
                    title: Text(asset['name']),
                    subtitle: Text("Warranty: ${asset['warrantyStart']} - ${asset['warrantyEnd']}"),
                    trailing: Icon(Icons.receipt),
                    onTap: _pickBillFile,
                  ),
                TextButton.icon(
                  onPressed: _addAsset,
                  icon: Icon(Icons.add),
                  label: Text("Add Asset"),
                )
              ],
            ),

            ExpansionTile(
              title: Text("Family Details"),
              children: [
                for (var member in familyMembers)
                  ListTile(
                    title: Text(member['name']),
                    subtitle: Text("DOB: ${member['dob']} | Mobile: ${member['mobile']}"),
                    trailing: Text("Age: ${member['age']}"),
                  ),
                TextButton.icon(
                  onPressed: _addFamilyMember,
                  icon: Icon(Icons.add),
                  label: Text("Add Member"),
                )
              ],
            ),

            ExpansionTile(
              title: Text("Vehicle Details"),
              children: [
                for (var v in vehicles)
                  ListTile(
                    title: Text(v['number']),
                    subtitle: Text("Owner: ${v['owner']} | Insurance: ${v['insurance']}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("PUC: ${v['puc']}"),
                        Text("Fines: ${v['fines']}"),
                      ],
                    ),
                  ),
                TextButton.icon(
                  onPressed: _addVehicle,
                  icon: Icon(Icons.add),
                  label: Text("Add Vehicle"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}