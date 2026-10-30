import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// Screen allowing the report owner to edit details of an existing report
class EditReportScreen extends StatefulWidget {
  final ItemReport report;

  const EditReportScreen({super.key, required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;

  late String _selectedCategory;
  late ItemType _selectedType;
  late ItemStatus _selectedStatus;
  late DateTime _eventDate;
  String? _selectedImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.report;
    _titleController = TextEditingController(text: r.title);
    _descController = TextEditingController(text: r.description);
    _locationController = TextEditingController(text: r.location);
    _contactController = TextEditingController(text: r.contactInfo ?? '');
    _selectedCategory = r.category;
    _selectedType = r.type;
    _selectedStatus = r.status;
    _eventDate = r.eventDate;
    _selectedImagePath = r.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access image: ${e.toString()}'),
            backgroundColor: AppColors.lostRed,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now().subtract(const Duration(days: 120)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = widget.report.copyWith(
      title: _titleController.text.trim(),
      type: _selectedType,
      category: _selectedCategory,
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      eventDate: _eventDate,
      imagePath: _selectedImagePath,
      contactInfo: _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : null,
      status: _selectedStatus,
      updatedAt: DateTime.now(),
    );

    final itemProvider = context.read<ItemProvider>();
    await itemProvider.updateReport(updated);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report updated successfully!'),
          backgroundColor: AppColors.foundGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Report')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Type & Status Toggles
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<ItemType>(
                        segments: const [
                          ButtonSegment(
                            value: ItemType.lost,
                            label: Text('Lost'),
                            icon: Icon(Icons.search_off_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: ItemType.found,
                            label: Text('Found'),
                            icon: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                            ),
                          ),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (val) {
                          setState(() => _selectedType = val.first);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<ItemStatus>(
                        segments: const [
                          ButtonSegment(
                            value: ItemStatus.open,
                            label: Text('Open Status'),
                            icon: Icon(Icons.timelapse_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: ItemStatus.resolved,
                            label: Text('Resolved'),
                            icon: Icon(Icons.task_alt_rounded, size: 16),
                          ),
                        ],
                        selected: {_selectedStatus},
                        onSelectionChanged: (val) {
                          setState(() => _selectedStatus = val.first);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                CustomTextField(
                  controller: _titleController,
                  label: 'Item Title *',
                  prefixIcon: Icons.title_rounded,
                  validator: (v) => Validators.requiredField(v, 'Item Title'),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    prefixIcon: const Icon(Icons.category_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.cardColor.withOpacity(0.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: CategoryInfo.allCategories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.key,
                          child: Row(
                            children: [
                              Icon(c.icon, size: 18),
                              const SizedBox(width: 10),
                              Text(c.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Location
                CustomTextField(
                  controller: _locationController,
                  label: 'Campus Location *',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => Validators.requiredField(v, 'Location'),
                ),
                const SizedBox(height: 16),

                // Date Picker
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Event Date *',
                      prefixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.cardColor.withOpacity(0.5),
                    ),
                    child: Text(
                      DateFormat('EEEE, MMMM d, y').format(_eventDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                CustomTextField(
                  controller: _descController,
                  label: 'Description *',
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 4,
                  validator: (v) => Validators.requiredField(v, 'Description'),
                ),
                const SizedBox(height: 16),

                // Contact Info
                CustomTextField(
                  controller: _contactController,
                  label: 'Contact Info / Instructions',
                  prefixIcon: Icons.contact_phone_outlined,
                ),
                const SizedBox(height: 16),

                // Image Section
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                    color: theme.cardColor.withOpacity(0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Item Photo (Optional)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 18,
                            ),
                            label: Text(
                              _selectedImagePath == null
                                  ? 'Select Image'
                                  : 'Change Image',
                            ),
                          ),
                        ],
                      ),
                      if (_selectedImagePath != null &&
                          !kIsWeb &&
                          File(_selectedImagePath!).existsSync()) ...[
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImagePath!),
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            IconButton(
                              icon: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() => _selectedImagePath = null);
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Save Button
                PrimaryButton(
                  label: 'Save Changes',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _saveChanges,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
