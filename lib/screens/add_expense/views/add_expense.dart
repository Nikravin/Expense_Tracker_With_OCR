import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/add_expense/bloc/add_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/model/add_trancation_model.dart';
import 'package:expense_tracker/screens/add_expense/model/expense_category.dart';
import 'package:expense_tracker/screens/add_expense/model/income_category.dart';
import 'package:expense_tracker/screens/home/views/home_screen.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/utils/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddExpense extends StatefulWidget {
  final String userId;

  const AddExpense({super.key, required this.userId});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final DateTime _selectDate = DateTime.now();
  bool _check = false;
  String _errorMsg = "";
  bool _expenseCheck = true;
  String? _dropDownCategory;
  bool isCustomCategory = false;
  
  // Image picker variables
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  // Method to handle image picking
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Method to upload image and get URL
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('expense_images/${randomAlphaNumeric(15)}');
      final uploadTask = await storageRef.putFile(_selectedImage!);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }


  Future<void> _validateTextField() async {
    final value = _amountController.text;
    final amount = double.tryParse(value);
    String note = _noteController.text;

    if (value.isEmpty || amount == null || amount <= 0) {
      setState(() {
        _check = true;
        _errorMsg = "Invalid Amount!";
      });
    } else if (_dropDownCategory == null) {
      if (_categoryController.text.isEmpty) {
        setState(() {
          _check = true;
          _errorMsg = "Please select or write a Category!";
        });
      }
    } else if (_dateController.text.isEmpty) {
      setState(() {
        _check = true;
        _errorMsg = "Please Select Date!";
      });
    } else {
      String transactionId = randomAlphaNumeric(15);
      String? imageUrl = await _uploadImage();
      
      context.read<AddExpenseBloc>().add(
        SubmitTrancation(
          addTrancationModel: AddTrancationModel(
            transactionId: transactionId,
            amount: amount,
            type: _expenseCheck ? "Expense" : "Income",
            date: _selectDate,
            createdat: Timestamp.now(),
            category: isCustomCategory
                ? _categoryController.text.capitalizeFirst()
                : _dropDownCategory.toString(),
            imageUrl: imageUrl ?? "",
            note: note,
          ),
        ),
      );
      setState(() {
        _check = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> finalCategoryList = _expenseCheck
        ? expenseCategories
        : incomeCategories;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _validateTextField();
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: BlocConsumer<AddExpenseBloc, AddExpenseState>(
              listener: (context, state) {
                if (state is AddTransactionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green,
                        ),
                        child: Text(
                          "${_expenseCheck ? "Expense" : "Income"} added successfully.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else if (state is AddTransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.transactionBackIconColor(
                                  context,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _expenseCheck
                                      ? Colors.red.shade50
                                      : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: _expenseCheck
                                        ? Colors.red.shade200
                                        : Colors.green.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _expenseCheck
                                          ? Icons.remove_circle_outline
                                          : Icons.add_circle_outline,
                                      color: _expenseCheck
                                          ? Colors.red.shade600
                                          : Colors.green.shade600,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Add ${_expenseCheck ? "Expense" : "Income"}",
                                      style: TextStyle(
                                        color: _expenseCheck
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 50), // Balance the spacing
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTypeButton("Expense", _expenseCheck),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildTypeButton("Income", !_expenseCheck),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: _amountController,
                      hint: "amount (e.g \$400.00)",
                      icon: FontAwesomeIcons.dollarSign,
                      inputType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      maxLength: 10,
                    ),
                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: _expenseCheck
                              ? "Select category (e.g Rent)"
                              : "Select category (e.g Salary)",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.apps,
                              color: Colors.grey.shade500,
                              size: 22,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor(context),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        value: _dropDownCategory,
                        items: finalCategoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _dropDownCategory = value;
                            isCustomCategory = value == 'Add own category';
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    isCustomCategory
                        ? _buildTextField(
                            controller: _categoryController,
                            hint: _expenseCheck
                                ? "category (e.g Rent, Food)"
                                : "category (e.g Salary)",
                            icon: Icons.category,
                            maxLength: 30,
                          )
                        : SizedBox(),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _noteController,
                      hint: _expenseCheck
                          ? "note (e.g Pay a house rent)"
                          : "note (e.g Job Salary credit)",
                      icon: Icons.note_alt,
                      maxLength: 50,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        // onTap: () async {
                        //   DateTime? newDate = await showDatePicker(
                        //     context: context,
                        //     initialDate: _selectDate,
                        //     firstDate: DateTime.now(),
                        //     lastDate: DateTime.now().add(
                        //       const Duration(days: 365),
                        //     ),
                        //   );
                        //   if (newDate != null) {
                        //     setState(() {
                        //       _selectDate = newDate;
                        //       _dateController.text = DateFormat(
                        //         'dd/MM/yyyy',
                        //       ).format(newDate);
                        //     });
                        //   }
                        // },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                        decoration: InputDecoration(
                          hintText: "Select date",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              FontAwesomeIcons.calendar,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor(context),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                      const SizedBox(height: 15),

                      // Image Picker Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.grey.shade500,
                                  size: 22,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Add Receipt/Image (Optional)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            if (_selectedImage != null)
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (_isUploadingImage)
                              Container(
                                height: 60,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppTheme.primaryColor(context),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Uploading image...",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _pickImage(ImageSource.camera),
                                    icon: Icon(Icons.camera_alt, size: 18),
                                    label: Text("Camera"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.grey.shade700,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _pickImage(ImageSource.gallery),
                                    icon: Icon(Icons.photo_library, size: 18),
                                    label: Text("Gallery"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.grey.shade700,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_selectedImage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: Text(
                                    "Remove Image",
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),
                    if (_check)
                      Text(
                        _errorMsg,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _check
                              ? AppTheme.outlineColor(context)
                              : AppTheme.primaryColor(context),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _validateTextField,
                        child: state is AddTransactionLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            : Text("Save", style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expenseCheck = label == "Expense";
          if (_dropDownCategory != null) {
            if (!selected) {
              _dropDownCategory = null;
              isCustomCategory = false;
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: double.infinity,
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor(context).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                label == "Expense" ? Icons.trending_down : Icons.trending_up,
                color: selected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLength = 30,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? inputType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          prefixIcon: Container(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.grey.shade500, size: 22),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor(context),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
