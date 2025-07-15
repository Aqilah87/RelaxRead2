// lib/ebook_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:uuid/uuid.dart'; // Make sure you have uuid in your pubspec.yaml
import 'package:relaxread2/user/book.dart'; // Assuming this is where your Book class is defined
import '../theme_provider.dart'; // Add this import

class EbookFormPage extends StatefulWidget {
  final Book? ebook; // Nullable for adding, non-null for editing

  const EbookFormPage({super.key, this.ebook});

  @override
  State<EbookFormPage> createState() => _EbookFormPageState();
}

class _EbookFormPageState extends State<EbookFormPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _imageUrlController;
  late TextEditingController _personalNoteController;
  late TextEditingController _pageNumberController;
  late TextEditingController _monthPublishController;
  late TextEditingController _yearPublisherController;
  late TextEditingController _publisherController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.ebook?.title ?? '');
    _authorController = TextEditingController(text: widget.ebook?.author ?? '');
    _imageUrlController = TextEditingController(
      text: widget.ebook?.imageUrl ?? '',
    );
    _personalNoteController = TextEditingController(
      text: widget.ebook?.personalNote ?? '',
    );
    _pageNumberController = TextEditingController(
      text: widget.ebook?.pageNumber?.toString() ?? '',
    );
    _monthPublishController = TextEditingController(
      text: widget.ebook?.month_publish ?? '',
    );
    _yearPublisherController = TextEditingController(
      text: widget.ebook?.yearPublisher?.toString() ?? '',
    );
    _publisherController = TextEditingController(
      text: widget.ebook?.publisher ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    _personalNoteController.dispose();
    _pageNumberController.dispose();
    _monthPublishController.dispose();
    _yearPublisherController.dispose();
    _publisherController.dispose();
    super.dispose();
  }

  void _saveEbook() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // Generate a new ID if adding, otherwise use existing
      final String ebookId = widget.ebook?.ebookId ?? const Uuid().v4();

      final newEbook = Book(
        ebookId: ebookId,
        title: _titleController.text,
        author: _authorController.text,
        imageUrl: _imageUrlController.text,
        personalNote: _personalNoteController.text,
        pageNumber: int.tryParse(_pageNumberController.text),
        month_publish: _monthPublishController.text,
        yearPublisher: _yearPublisherController.text,
        publisher: _publisherController.text,
      );

      // In a real application, you would send this to a database or API
      // For this example, we'll just print it and pop
      print('Saving Ebook: $newEbook');

      // Simulate a network request
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          Navigator.pop(context, newEbook); // Pass the new/updated ebook back
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Dynamic colors based on theme
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFE8F5E9); // Light green for light mode
    final Color appBarColor = isDarkMode
        ? const Color(0xFF1F1F1F)
        : Colors.white;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headingColor = isDarkMode ? primaryGreen : loginPrimaryGreen;
    final Color inputFillColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : Colors.white;
    final Color inputBorderColor = isDarkMode
        ? Colors.grey[600]!
        : primaryGreen.withOpacity(0.4);
    final Color focusedInputBorderColor = isDarkMode
        ? primaryGreen
        : loginPrimaryGreen;

    return Scaffold(
      backgroundColor: backgroundColor, // Use dynamic background color
      appBar: AppBar(
        backgroundColor: appBarColor, // Use dynamic app bar color
        elevation: 1.0,
        title: Text(
          widget.ebook == null ? 'Add New Ebook' : 'Edit Ebook',
          style: TextStyle(
            color: headingColor, // Use dynamic heading color
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: headingColor), // Back button color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  widget.ebook == null ? Icons.add_box : Icons.edit,
                  size: 80,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.ebook == null
                      ? 'Enter Ebook Details'
                      : 'Update Ebook Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: headingColor, // Use dynamic heading color
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Book Details',
                headingColor,
              ), // Pass headingColor
              _buildTextField(
                controller: _titleController,
                labelText: 'Title',
                icon: Icons.title,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _authorController,
                labelText: 'Author',
                icon: Icons.person,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _imageUrlController,
                labelText: 'Image URL',
                icon: Icons.image,
                isOptional: true,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _personalNoteController,
                labelText: 'Personal Note',
                icon: Icons.note,
                isOptional: true,
                maxLines: 3,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _pageNumberController,
                labelText: 'Page Number',
                icon: Icons.pages,
                keyboardType: TextInputType.number,
                isOptional: true,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _monthPublishController,
                labelText: 'Month Published (e.g., January)',
                icon: Icons.calendar_today,
                isOptional: true,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _yearPublisherController,
                labelText: 'Year Published',
                icon: Icons.date_range,
                keyboardType: TextInputType.number,
                isOptional: true,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              _buildTextField(
                controller: _publisherController,
                labelText: 'Publisher',
                icon: Icons.business,
                isOptional: true,
                textColor: textColor,
                inputFillColor: inputFillColor,
                inputBorderColor: inputBorderColor,
                focusedInputBorderColor: focusedInputBorderColor,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveEbook,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          widget.ebook == null ? Icons.add_circle : Icons.save,
                          color: Colors.white,
                        ),
                  label: Text(
                    _isSaving
                        ? 'Saving...'
                        : widget.ebook == null
                        ? 'Add Ebook'
                        : 'Save Changes',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen, // Consistent button color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
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
    required String labelText,
    required IconData icon,
    bool isOptional = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required Color textColor,
    required Color inputFillColor,
    required Color inputBorderColor,
    required Color focusedInputBorderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: textColor), // Dynamic text color
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: textColor.withOpacity(0.8),
          ), // Dynamic label color
          prefixIcon: Icon(icon, color: primaryGreen), // Consistent icon color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: inputBorderColor,
            ), // Dynamic border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: focusedInputBorderColor, // Dynamic focused border color
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: inputBorderColor,
            ), // Dynamic enabled border color
          ),
          filled: true,
          fillColor: inputFillColor, // Dynamic fill color
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Please enter $labelText';
          }
          if (keyboardType == TextInputType.number &&
              value != null &&
              value.isNotEmpty &&
              int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color, // Use the passed color
        ),
      ),
    );
  }
}
