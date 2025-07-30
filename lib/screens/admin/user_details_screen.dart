// lib/screens/admin/user_details_screen.dart
import 'dart:io';
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

  Future<void> _pickBillFile({int? assetIndex}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        // Make sure we have a valid file path
        final String filePath = pickedFile.path;
        final file = File(filePath);
        
        // Check if file exists
        if (!file.existsSync()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: File not found at selected location"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        if (assetIndex != null) {
          setState(() {
            assets[assetIndex]['billImage'] = filePath;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Bill uploaded successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error selecting file: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _captureImage({int? assetIndex}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 1800,
        maxWidth: 1800,
        imageQuality: 90,
      );
      
      if (pickedFile != null) {
        // Make sure we have a valid file path
        final String filePath = pickedFile.path;
        final file = File(filePath);
        
        // Check if file exists
        if (!file.existsSync()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: File not found after capture"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        if (assetIndex != null) {
          setState(() {
            assets[assetIndex]['billImage'] = filePath;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Bill captured successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print("Error capturing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error capturing image: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _viewUploadedFile(String filePath) {
    try {
      print("Attempting to view file: $filePath");
      
      if (filePath.isEmpty) {
        print("Error: Empty file path provided");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Empty file path provided"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final file = File(filePath);
      if (!file.existsSync()) {
        print("File not found at path: $filePath");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File not found: The attachment may have been moved or deleted."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Check if file has content
      if (file.lengthSync() <= 0) {
        print("File exists but is empty: $filePath");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: The file is empty"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      print("Opening file preview dialog");
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: EdgeInsets.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text("Uploaded Document"),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                child,
                                CircularProgressIndicator(),
                              ],
                            );
                          }
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image in viewer: $error");
                          print("Stack trace: $stackTrace");
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 64, color: Colors.red),
                              SizedBox(height: 16),
                              Text("Could not load image",
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text("File may be corrupted or in an unsupported format",
                                  textAlign: TextAlign.center),
                              SizedBox(height: 16),
                              Text("Path: $filePath",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center),
                              SizedBox(height: 16),
                              Text("Error: ${error.toString()}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print("Error displaying file: $e");
      print("Stack trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error displaying file: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        try {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.rear,
                            maxHeight: 1800,
                            maxWidth: 1800,
                            imageQuality: 90,
                          );
                          
                          if (pickedFile != null) {
                            final String filePath = pickedFile.path;
                            final file = File(filePath);
                            
                            if (!file.existsSync()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: File not found after capture"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            setState(() {
                              billImagePath = filePath;
                            });
                          }
                        } catch (e) {
                          print("Error capturing image: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error capturing image: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                      label: Text("Camera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          print("Starting gallery picker");
                          final picker = ImagePicker();
                          
                          // Pick image with less restrictive settings
                          final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                            // Remove height/width/quality restrictions that might cause issues
                          );
                          
                          print("Picked file result: $pickedFile");
                          
                          if (pickedFile == null) {
                            print("No file was picked (user cancelled)");
                            return;
                          }
                          
                          // Get file path and check it
                          final String filePath = pickedFile.path;
                          print("File path from picker: $filePath");
                          
                          // Check file path is not empty
                          if (filePath.isEmpty) {
                            print("Error: Empty file path received from picker");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: Invalid file path from gallery"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          
                          // Create File object and check if exists
                          final file = File(filePath);
                          final bool fileExists = file.existsSync();
                          print("File exists check: $fileExists");
                          
                          if (!fileExists) {
                            print("File does not exist at path: $filePath");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: File not found at selected location"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          
                          // Check file size
                          try {
                            final fileSize = await file.length();
                            print("File size: $fileSize bytes");
                            
                            if (fileSize <= 0) {
                              print("File exists but has zero size");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: Selected file is empty"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                          } catch (sizeError) {
                            print("Error checking file size: $sizeError");
                          }
                          
                          // If we got here, the file should be valid
                          print("Setting image path: $filePath");
                          setState(() {
                            billImagePath = filePath;
                          });
                          
                          print("File selected successfully");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Image selected successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e, stackTrace) {
                          // More detailed error logging
                          print("Error picking file: $e");
                          print("Stack trace: $stackTrace");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error selecting file: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("Upload"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                // Show upload status and preview
                billImagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bill uploaded successfully!", 
                                style: TextStyle(color: Colors.green)),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Stack(
                                      children: [
                                        // Placeholder in case image fails to load
                                        Container(
                                          height: 80,
                                          width: 80,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(Icons.image, color: Colors.grey[400]),
                                          ),
                                        ),
                                        // Actual image
                                        Image.file(
                                          File(billImagePath!),
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            print("Error loading image in add dialog: $error");
                                            print("Error stack trace: $stackTrace");
                                            return Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.broken_image, color: Colors.red, size: 20),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Error loading",
                                                    style: TextStyle(fontSize: 10, color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                title: Text("Bill Attachment"),
                                subtitle: Text(billImagePath!.split('/').last),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      billImagePath = null;
                                    });
                                  },
                                ),
                                onTap: () => _viewUploadedFile(billImagePath!),
                              ),
                            )
                          ],
                        ),
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
  
  void _confirmSaveUserDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Update"),
        content: Text("Are you sure you want to update the details for ${widget.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveUserDetails();
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
  
  void _saveUserDetails() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Create a map of the updated user data
      final Map<String, dynamic> userData = {
        'id': widget.consumerId,
        'name': _nameController.text,
        'address': {
          'flatNo': _flatController.text,
          'sector': _sectorController.text,
          'floor': _floorController.text,
          'landmark': _landmarkController.text,
          'area': _areaController.text,
          'plot': _plotController.text,
          'city': _cityController.text,
          'buildingName': _buildingController.text,
          'pincode': _pincodeController.text,
        },
        'assets': assets,
        'familyMembers': familyMembers,
        'vehicles': vehicles,
      };
      
      // Here you would typically call your API or service to update the data
      // For demonstration, we're simulating an API call
      await Future.delayed(Duration(seconds: 1));
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User details updated successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Optional: Navigate back after saving
      // Navigator.pop(context);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update user details: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save Changes',
            onPressed: _confirmSaveUserDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Consumer ID: ${widget.consumerId}", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                suffixIcon: Icon(Icons.edit, size: 18),
                helperText: "Tap to edit user name"
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Divider(),
            Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildTextField("Flat No", _flatController),
                    _buildTextField("Sector No", _sectorController),
                    _buildTextField("Floor", _floorController),
                    _buildTextField("Landmark", _landmarkController),
                    _buildTextField("Area", _areaController),
                    _buildTextField("Plot", _plotController),
                    _buildTextField("City", _cityController),
                    _buildTextField("Building Name", _buildingController),
                    _buildTextField("Pincode", _pincodeController),
                  ],
                ),
              ),
            ),

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
                            
                            // Bill attachment preview (if exists)
                            if (asset['billImage'] != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Stack(
                                      children: [
                                        // Placeholder in case image fails to load
                                        Container(
                                          height: 80,
                                          width: 80,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(Icons.image, color: Colors.grey[400]),
                                          ),
                                        ),
                                        // Actual image
                                        Image.file(
                                          File(asset['billImage']),
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            print("Error loading image in asset list: $error");
                                            return Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.broken_image, color: Colors.red, size: 20),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Error",
                                                    style: TextStyle(fontSize: 10, color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Bill Attachment", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(asset['billImage'].split('/').last, 
                                              style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                asset['billImage'] != null
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton.icon(
                                            icon: Icon(Icons.receipt),
                                            label: Text("View Bill"),
                                            onPressed: () {
                                              _viewUploadedFile(asset['billImage']);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            tooltip: "Remove attachment",
                                            onPressed: () {
                                              setState(() {
                                                asset['billImage'] = null;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton.icon(
                                            icon: Icon(Icons.camera_alt),
                                            label: Text("Capture"),
                                            onPressed: () => _captureImage(assetIndex: assets.indexOf(asset)),
                                          ),
                                          TextButton.icon(
                                            icon: Icon(Icons.upload_file),
                                            label: Text("Upload"),
                                            onPressed: () => _pickBillFile(assetIndex: assets.indexOf(asset)),
                                          ),
                                        ],
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