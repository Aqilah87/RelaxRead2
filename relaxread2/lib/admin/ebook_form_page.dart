// lib/ebook_form_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Make sure you have uuid in your pubspec.yaml
import 'package:relaxread2/user/book.dart'; // Assuming this is where your Book class is defined

class EbookFormPage extends StatefulWidget {
  final Book? ebook; // Nullable for adding, non-null for editing

  const EbookFormPage({super.key, this.ebook});

  @override
  State<EbookFormPage> createState() => _EbookFormPageState();
}

class _EbookFormPageState extends State<EbookFormPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);
  static const Color lightGreen = Color(
    0xFFE8F5E9,
  ); // A lighter shade for backgrounds

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

    // Initialize controllers with existing ebook data if editing
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
      text: widget.ebook?.yearPublisher ?? '',
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final String currentEbookId = widget.ebook?.ebookId ?? const Uuid().v4();

    final newOrUpdatedBook = Book(
      ebookId: currentEbookId,
      title: _titleController.text,
      author: _authorController.text,
      imageUrl: _imageUrlController.text.isNotEmpty
          ? _imageUrlController.text
          : null,
      personalNote: _personalNoteController.text.isNotEmpty
          ? _personalNoteController.text
          : null,
      pageNumber: int.tryParse(_pageNumberController.text),
      month_publish: _monthPublishController.text.isNotEmpty
          ? _monthPublishController.text
          : null,
      yearPublisher: _yearPublisherController.text.isNotEmpty
          ? _yearPublisherController.text
          : null,
      publisher: _publisherController.text.isNotEmpty
          ? _publisherController.text
          : null,
    );

    Future.delayed(const Duration(milliseconds: 800)).then((_) {
      // Increased delay for visual effect
      setState(() {
        if (widget.ebook == null) {
          globalEbooks.add(newOrUpdatedBook);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ebook added successfully!')),
          );
        } else {
          final index = globalEbooks.indexWhere(
            (b) => b.ebookId == widget.ebook!.ebookId,
          );
          if (index != -1) {
            globalEbooks[index] = newOrUpdatedBook;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ebook updated successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Ebook not found for update!'),
              ),
            );
          }
        }
        _isSaving = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen, // Lighter background for the form page
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0, // Slightly more prominent shadow
        title: Text(
          widget.ebook == null ? 'Add New Ebook' : 'Edit Ebook',
          style: TextStyle(
            color: loginPrimaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Center the title
        iconTheme: IconThemeData(color: loginPrimaryGreen), // Back button color
      ),
      body: Stack(
        // Use Stack for the loading overlay
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0), // Increased padding
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Decorative header
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          widget.ebook == null ? Icons.library_add : Icons.book,
                          size: 80,
                          color: primaryGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.ebook == null
                              ? 'Enter Ebook Details'
                              : 'Edit Ebook Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // General Information Section
                  _buildSectionTitle('General Information'),
                  _buildTextField(
                    _titleController,
                    'Title',
                    'Please enter the ebook title',
                    icon: Icons.title,
                  ),
                  _buildTextField(
                    _authorController,
                    'Author',
                    'Please enter the author\'s name',
                    icon: Icons.person,
                  ),
                  _buildTextField(
                    _imageUrlController,
                    'Image URL',
                    'Please enter an image URL',
                    isOptional: true,
                    icon: Icons.image,
                  ),
                  _buildTextField(
                    _personalNoteController,
                    'Personal Note',
                    'Add a personal note about the ebook',
                    isOptional: true,
                    maxLines: 3,
                    icon: Icons.note,
                  ),
                  _buildTextField(
                    _pageNumberController,
                    'Page Number',
                    'Please enter the number of pages',
                    keyboardType: TextInputType.number,
                    isOptional: true,
                    icon: Icons.pages,
                  ),
                  const SizedBox(height: 24),

                  // Publication Details Section
                  _buildSectionTitle('Publication Details'),
                  _buildTextField(
                    _monthPublishController,
                    'Month Published',
                    'e.g., January, March',
                    isOptional: true,
                    icon: Icons.calendar_month,
                  ),
                  _buildTextField(
                    _yearPublisherController,
                    'Year Published',
                    'e.g., 2023',
                    keyboardType: TextInputType.number,
                    isOptional: true,
                    icon: Icons.date_range,
                  ),
                  _buildTextField(
                    _publisherController,
                    'Publisher',
                    'e.g., Penguin Random House',
                    isOptional: true,
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : _saveEbook, // Disable button while saving
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        widget.ebook == null ? 'Add Ebook' : 'Save Changes',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32, // Increased horizontal padding
                          vertical: 16, // Increased vertical padding
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ), // More rounded corners
                        ),
                        elevation: 5, // More prominent shadow
                        shadowColor: primaryGreen.withOpacity(
                          0.4,
                        ), // Custom shadow color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.4), // Translucent black overlay
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widget for text fields with enhanced decoration
  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
    int maxLines = 1,
    IconData? icon, // Optional icon for the text field
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ), // Increased vertical padding
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText, // Added hint text
          floatingLabelStyle: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: primaryGreen.withOpacity(0.7))
              : null, // Added prefix icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: primaryGreen.withOpacity(0.6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: loginPrimaryGreen,
              width: 2.5,
            ), // Thicker focused border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: primaryGreen.withOpacity(0.4)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ), // More padding inside
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Please enter $labelText'; // More specific validation message
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
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: loginPrimaryGreen,
        ),
      ),
    );
  }
}
