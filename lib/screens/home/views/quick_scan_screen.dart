import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expense_tracker/services/ocr_service.dart';
import 'package:expense_tracker/services/receipt_parser.dart';
import 'package:expense_tracker/screens/add_expense/model/add_trancation_model.dart';
import 'package:expense_tracker/screens/add_expense/bloc/add_expense_bloc.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

class QuickScanScreen extends StatefulWidget {
  final String currentUser;
  
  const QuickScanScreen({super.key, required this.currentUser});

  @override
  _QuickScanScreenState createState() => _QuickScanScreenState();
}

class _QuickScanScreenState extends State<QuickScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  XFile? _selectedImage;
  ReceiptData? _scannedData;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = 'Other';
  
  final List<String> _categories = [
    'Food',
    'Transportation', 
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Utilities',
    'Education',
    'Other'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _noteController.dispose();
    OCRService.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  Future<void> _showImageSourceDialog() async {
    await _requestPermissions();
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor(context)),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppTheme.primaryColor(context)),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isProcessing = true;
        });
        
        await _processImage(image);
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: ${e.toString()}');
    }
  }

  Future<void> _processImage(XFile image) async {
    try {
      final String? extractedText = await OCRService.extractTextFromXFile(image);
      
      if (extractedText != null && extractedText.trim().isNotEmpty) {
        final ReceiptData receiptData = ReceiptParser.parseReceipt(extractedText);
        
        setState(() {
          _scannedData = receiptData;
          _amountController.text = receiptData.amount?.toStringAsFixed(2) ?? '';
          _merchantController.text = receiptData.merchantName;
          _selectedCategory = receiptData.category;
          _noteController.text = 'Scanned from receipt';
          _isProcessing = false;
        });
        
        _showSuccessSnackBar('Receipt scanned successfully!');
      } else {
        setState(() {
          _isProcessing = false;
        });
        _showErrorSnackBar('No text found in the image. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Error processing image: ${e.toString()}');
    }
  }

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) {
      _showErrorSnackBar('Please enter an amount');
      return;
    }
    
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }
    
    try {
      final String transactionId = randomAlphaNumeric(15);
      final addExpenseBloc = context.read<AddExpenseBloc>();
      
      addExpenseBloc.add(
        SubmitTrancation(
          addTrancationModel: AddTrancationModel(
            transactionId: transactionId,
            amount: amount,
            type: 'Expense',
            date: DateTime.now(),
            createdat: Timestamp.now(),
            category: _selectedCategory,
            imageUrl: _selectedImage?.path ?? '',
            note: _noteController.text.isEmpty ? 'Scanned receipt' : _noteController.text,
          ),
        ),
      );
      
      // Refresh balance
      context.read<HomeScreenUserDetailBloc>().add(UserDetailsEvent());
      
      _showSuccessSnackBar('Expense saved successfully!');
      
      // Clear form
      setState(() {
        _selectedImage = null;
        _scannedData = null;
        _amountController.clear();
        _merchantController.clear();
        _noteController.clear();
        _selectedCategory = 'Other';
      });
    } catch (e) {
      _showErrorSnackBar('Error saving expense: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Quick Scan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor(context),
        iconTheme:IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scan Receipt Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 64,
                      color: AppTheme.primaryColor(context),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Scan Receipt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Take a photo or select from gallery to automatically extract expense details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _showImageSourceDialog,
                      icon: Icon(_isProcessing ? Icons.hourglass_empty : Icons.camera_alt),
                      label: Text(_isProcessing ? 'Processing...' : 'Scan Receipt'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor(context),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Show selected image
            if (_selectedImage != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedImage!.path),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            SizedBox(height: 16),
            
            // Processing indicator
            if (_isProcessing)
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.primaryColor(context),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Processing image...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Scanned data form
            if (_scannedData != null && !_isProcessing)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Amount field
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Merchant field
                      TextFormField(
                        controller: _merchantController,
                        decoration: InputDecoration(
                          labelText: 'Merchant/Vendor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Note field
                      TextFormField(
                        controller: _noteController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Note (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveExpense,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Expense',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

