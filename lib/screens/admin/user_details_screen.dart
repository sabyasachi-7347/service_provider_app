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
    // Controllers for asset form fields
    final assetIdController = TextEditingController();
    final assetNameController = TextEditingController();
    final categoryController = TextEditingController();
    final subCategoryController = TextEditingController();
    final locationController = TextEditingController();
    
    // Default dates
    DateTime warrantyStartDate = DateTime.now();
    DateTime warrantyEndDate = DateTime.now().add(Duration(days: 365));
    DateTime lastServiceDate = DateTime.now();
    DateTime serviceDueDate = DateTime.now().add(Duration(days: 90));
    
    // Function to select date
    Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
      );
      return picked;
    }
    
    // Bill upload status
    String? billImagePath;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Asset"),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: assetIdController,
                  decoration: InputDecoration(labelText: "Asset ID"),
                ),
                TextField(
                  controller: assetNameController,
                  decoration: InputDecoration(labelText: "Asset Name"),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                ),
                TextField(
                  controller: subCategoryController,
                  decoration: InputDecoration(labelText: "Sub-Category"),
                ),
                SizedBox(height: 10),
                
                // Warranty Start Date
                ListTile(
                  title: Text("Warranty Start Date"),
                  subtitle: Text("${warrantyStartDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await _selectDate(context, warrantyStartDate);
                    if (picked != null && picked != warrantyStartDate) {
                      setState(() {
                        warrantyStartDate = picked;
                      });
                    }
                  },
                ),
                
                // Warranty End Date
                ListTile(
                  title: Text("Warranty End Date"),
                  subtitle: Text("${warrantyEndDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await _selectDate(context, warrantyEndDate);
                    if (picked != null && picked != warrantyEndDate) {
                      setState(() {
                        warrantyEndDate = picked;
                      });
                    }
                  },
                ),
                
                // Last Service Date
                ListTile(
                  title: Text("Last Service Date"),
                  subtitle: Text("${lastServiceDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await _selectDate(context, lastServiceDate);
                    if (picked != null && picked != lastServiceDate) {
                      setState(() {
                        lastServiceDate = picked;
                      });
                    }
                  },
                ),
                
                // Service Due Date
                ListTile(
                  title: Text("Service Due Date"),
                  subtitle: Text("${serviceDueDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await _selectDate(context, serviceDueDate);
                    if (picked != null && picked != serviceDueDate) {
                      setState(() {
                        serviceDueDate = picked;
                      });
                    }
                  },
                ),
                
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: "Location"),
                ),
                
                SizedBox(height: 10),
                
                // Bill Upload Section
                Text("Bill Upload", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          setState(() {
                            billImagePath = pickedFile.path;
                          });
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                      label: Text("Camera"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            billImagePath = pickedFile.path;
                          });
                        }
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("Upload"),
                    ),
                  ],
                ),
                
                // Show upload status
                billImagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Bill uploaded successfully!", 
                            style: TextStyle(color: Colors.green)),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancel")
          ),
          ElevatedButton(
            onPressed: () {
              // Add asset to the list
              if (assetNameController.text.isNotEmpty) {
                setState(() {
                  assets.add({
                    'id': assetIdController.text,
                    'name': assetNameController.text,
                    'category': categoryController.text,
                    'subCategory': subCategoryController.text,
                    'warrantyStart': "${warrantyStartDate.toLocal()}".split(' ')[0],
                    'warrantyEnd': "${warrantyEndDate.toLocal()}".split(' ')[0],
                    'warrantyStatus': DateTime.now().isBefore(warrantyEndDate) ? 'Active' : 'Expired',
                    'lastServiceDate': "${lastServiceDate.toLocal()}".split(' ')[0],
                    'serviceDueDate': "${serviceDueDate.toLocal()}".split(' ')[0],
                    'location': locationController.text,
                    'billImage': billImagePath,
                  });
                });
                Navigator.pop(context);
              }
            }, 
            child: Text("Save")
          ),
        ],
      ),
    );
  }

  void _addFamilyMember() {
    // Controllers for family member form fields
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final healthInsuranceController = TextEditingController();
    
    // Default dates
    DateTime dateOfBirth = DateTime.now().subtract(Duration(days: 365 * 30)); // Default 30 years old
    DateTime insuranceExpiryDate = DateTime.now().add(Duration(days: 365)); // Default 1 year from now
    
    // Function to select date
    Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      return picked;
    }
    
    // Calculate age from DOB
    int calculateAge(DateTime birthDate) {
      final DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || 
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    }
    
    // Age state
    int age = calculateAge(dateOfBirth);
    
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Add Family Member"),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Member Name"),
                    ),
                    TextField(
                      controller: mobileController,
                      decoration: InputDecoration(labelText: "Mobile Number"),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    
                    // Date of Birth
                    ListTile(
                      title: Text("Date of Birth"),
                      subtitle: Text("${dateOfBirth.toLocal()}".split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await _selectDate(context, dateOfBirth);
                        if (picked != null && picked != dateOfBirth) {
                          setStateDialog(() {
                            dateOfBirth = picked;
                            age = calculateAge(dateOfBirth);
                          });
                        }
                      },
                    ),
                    
                    // Show calculated age
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("Age: $age years", 
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    
                    SizedBox(height: 10),
                    
                    TextField(
                      controller: healthInsuranceController,
                      decoration: InputDecoration(labelText: "Health Insurance"),
                    ),
                    
                    // Health Insurance Expiry Date
                    ListTile(
                      title: Text("Health Insurance Expiry Date"),
                      subtitle: Text("${insuranceExpiryDate.toLocal()}".split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await _selectDate(context, insuranceExpiryDate);
                        if (picked != null && picked != insuranceExpiryDate) {
                          setStateDialog(() {
                            insuranceExpiryDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Cancel")
              ),
              ElevatedButton(
                onPressed: () {
                  // Add family member to the list
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      familyMembers.add({
                        'name': nameController.text,
                        'mobile': mobileController.text,
                        'dob': "${dateOfBirth.toLocal()}".split(' ')[0],
                        'age': age,
                        'healthInsurance': healthInsuranceController.text,
                        'insuranceExpiry': "${insuranceExpiryDate.toLocal()}".split(' ')[0],
                      });
                    });
                    Navigator.pop(context);
                  }
                }, 
                child: Text("Save")
              ),
            ],
          );
        }
      ),
    );
  }

  void _addVehicle() {
    // Controllers for vehicle form fields
    final vehicleNumberController = TextEditingController();
    final ownerController = TextEditingController();
    final insuranceController = TextEditingController();
    final pucController = TextEditingController();
    final finesController = TextEditingController();
    
    // Default dates
    DateTime insuranceExpiryDate = DateTime.now().add(Duration(days: 365));
    DateTime pucExpiryDate = DateTime.now().add(Duration(days: 180));
    
    // Function to select date
    Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
      );
      return picked;
    }
    
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Add Vehicle"),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: vehicleNumberController,
                      decoration: InputDecoration(labelText: "Vehicle Number"),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    TextField(
                      controller: ownerController,
                      decoration: InputDecoration(labelText: "Owner Name"),
                    ),
                    SizedBox(height: 10),
                    
                    // Insurance Section
                    Text("Insurance Details", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: insuranceController,
                      decoration: InputDecoration(labelText: "Insurance Policy Number"),
                    ),
                    
                    // Insurance Expiry Date
                    ListTile(
                      title: Text("Insurance Expiry Date"),
                      subtitle: Text("${insuranceExpiryDate.toLocal()}".split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await _selectDate(context, insuranceExpiryDate);
                        if (picked != null && picked != insuranceExpiryDate) {
                          setStateDialog(() {
                            insuranceExpiryDate = picked;
                          });
                        }
                      },
                    ),
                    
                    SizedBox(height: 10),
                    
                    // PUC Section
                    Text("PUC Details", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: pucController,
                      decoration: InputDecoration(labelText: "PUC Certificate Number"),
                    ),
                    
                    // PUC Expiry Date
                    ListTile(
                      title: Text("PUC Expiry Date"),
                      subtitle: Text("${pucExpiryDate.toLocal()}".split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await _selectDate(context, pucExpiryDate);
                        if (picked != null && picked != pucExpiryDate) {
                          setStateDialog(() {
                            pucExpiryDate = picked;
                          });
                        }
                      },
                    ),
                    
                    SizedBox(height: 10),
                    
                    // Fines/Challans Section
                    Text("Fines/Challans", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: finesController,
                      decoration: InputDecoration(labelText: "Pending Fines/Challans"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Cancel")
              ),
              ElevatedButton(
                onPressed: () {
                  // Add vehicle to the list
                  if (vehicleNumberController.text.isNotEmpty) {
                    setState(() {
                      vehicles.add({
                        'number': vehicleNumberController.text,
                        'owner': ownerController.text,
                        'insurance': insuranceController.text,
                        'insuranceExpiry': "${insuranceExpiryDate.toLocal()}".split(' ')[0],
                        'insuranceStatus': DateTime.now().isBefore(insuranceExpiryDate) ? 'Valid' : 'Expired',
                        'puc': pucController.text,
                        'pucExpiry': "${pucExpiryDate.toLocal()}".split(' ')[0],
                        'pucStatus': DateTime.now().isBefore(pucExpiryDate) ? 'Valid' : 'Expired',
                        'fines': finesController.text,
                      });
                    });
                    Navigator.pop(context);
                  }
                }, 
                child: Text("Save")
              ),
            ],
          );
        }
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
                  ExpansionTile(
                    title: Text("${asset['name']} (${asset['id']})"),
                    subtitle: Text("Category: ${asset['category']} | ${asset['subCategory']}"),
                    leading: Icon(Icons.devices),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Warranty Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                                Chip(
                                  label: Text(asset['warrantyStatus']),
                                  backgroundColor: asset['warrantyStatus'] == 'Active' 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("Warranty Period: ${asset['warrantyStart']} to ${asset['warrantyEnd']}"),
                            Text("Last Service: ${asset['lastServiceDate']}"),
                            Text("Service Due: ${asset['serviceDueDate']}"),
                            Text("Location: ${asset['location']}"),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                asset['billImage'] != null
                                    ? TextButton.icon(
                                        icon: Icon(Icons.receipt),
                                        label: Text("View Bill"),
                                        onPressed: () {
                                          // Show bill image
                                        },
                                      )
                                    : TextButton.icon(
                                        icon: Icon(Icons.upload_file),
                                        label: Text("Upload Bill"),
                                        onPressed: _pickBillFile,
                                      ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: _addAsset,
                    icon: Icon(Icons.add),
                    label: Text("Add Asset"),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),

            ExpansionTile(
              title: Text("Family Details"),
              children: [
                for (var member in familyMembers)
                  ExpansionTile(
                    title: Text(member['name']),
                    subtitle: Text("Age: ${member['age']} | Mobile: ${member['mobile']}"),
                    leading: Icon(Icons.person),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date of Birth: ${member['dob']}"),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Health Insurance: ${member['healthInsurance']}"),
                                Chip(
                                  label: Text("Expires: ${member['insuranceExpiry']}"),
                                  backgroundColor: DateTime.now().isBefore(
                                      DateTime.parse(member['insuranceExpiry'])) 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: _addFamilyMember,
                    icon: Icon(Icons.add),
                    label: Text("Add Member"),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),

            ExpansionTile(
              title: Text("Vehicle Details"),
              children: [
                for (var vehicle in vehicles)
                  ExpansionTile(
                    title: Text(vehicle['number']),
                    subtitle: Text("Owner: ${vehicle['owner']}"),
                    leading: Icon(Icons.directions_car),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Insurance Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Insurance: ${vehicle['insurance']}", 
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Chip(
                                  label: Text(vehicle['insuranceStatus']),
                                  backgroundColor: vehicle['insuranceStatus'] == 'Valid' 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                ),
                              ],
                            ),
                            Text("Expires on: ${vehicle['insuranceExpiry']}"),
                            SizedBox(height: 8),
                            
                            // PUC Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PUC: ${vehicle['puc']}", 
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Chip(
                                  label: Text(vehicle['pucStatus']),
                                  backgroundColor: vehicle['pucStatus'] == 'Valid' 
                                      ? Colors.green[100] 
                                      : Colors.red[100],
                                ),
                              ],
                            ),
                            Text("Expires on: ${vehicle['pucExpiry']}"),
                            SizedBox(height: 8),
                            
                            // Fines Section
                            Text("Fines/Challans:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(vehicle['fines'].isEmpty ? "No pending fines" : vehicle['fines']),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: _addVehicle,
                    icon: Icon(Icons.add),
                    label: Text("Add Vehicle"),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}