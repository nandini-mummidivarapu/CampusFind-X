import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

/// Screen for reporting a lost item on campus
class ReportLostScreen extends StatefulWidget {
  static const String routeName = '/report-lost';

  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  String _selectedCategory = 'idCard';
  DateTime _eventDate = DateTime.now();
  String? _selectedImagePath;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      final user = auth.currentUser!;
      _contactController.text =
          '${user.fullName} • Phone: ${user.phone ?? 'N/A'} • Email: ${user.email}';
    }
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
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  void _submitReport() async {
    final auth = context.read<AuthProvider>();

    // If user is not logged in, prompt them
    if (!auth.isLoggedIn) {
      final shouldLogin = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Login Required'),
          content: const Text(
            'You must be signed in with a campus demo account to report lost belongings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign In / Demo'),
            ),
          ],
        ),
      );

      if (shouldLogin == true && mounted) {
        await Navigator.pushNamed(context, LoginScreen.routeName);
        if (!mounted || !auth.isLoggedIn) return;
      } else {
        return;
      }
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final currentUser = auth.currentUser!;
    final newReport = ItemReport(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      type: ItemType.lost,
      category: _selectedCategory,
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      eventDate: _eventDate,
      imagePath: _selectedImagePath,
      contactInfo: _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : '${currentUser.fullName} (${currentUser.email})',
      reporterId: currentUser.id,
      reporterName: currentUser.fullName,
      status: ItemStatus.open,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final itemProvider = context.read<ItemProvider>();
    await itemProvider.addReport(newReport);

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lost item report published successfully!'),
          backgroundColor: AppColors.foundGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Report Lost Item')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top guidance banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.lostRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.lostRed.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.lostRed,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Provide clear details and specific campus locations so students can easily recognize your lost item.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                CustomTextField(
                  controller: _titleController,
                  label: 'Item Title *',
                  hint: 'e.g., Blue Milton 750ml Water Bottle',
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
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

                // Location Field + Quick Suggestions
                CustomTextField(
                  controller: _locationController,
                  label: 'Campus Location Where Lost *',
                  hint: 'e.g., Central Library 2nd Floor',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) =>
                      Validators.requiredField(v, 'Campus Location'),
                ),
                const SizedBox(height: 8),

                // Quick campus location chips
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppConstants.campusLocations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final loc = AppConstants.campusLocations[index];
                      return ActionChip(
                        label: Text(loc, style: const TextStyle(fontSize: 11)),
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        onPressed: () {
                          _locationController.text = loc;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Date Lost Picker Button
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date Lost *',
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
                  label: 'Detailed Description *',
                  hint:
                      'Mention color, brand, markings, scratches, or any unique identification features...',
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 4,
                  validator: (v) =>
                      Validators.requiredField(v, 'Item Description'),
                ),
                const SizedBox(height: 16),

                // Optional Contact Info
                CustomTextField(
                  controller: _contactController,
                  label: 'Contact Details (Optional)',
                  hint: 'Phone number, student email, or hostel room',
                  prefixIcon: Icons.contact_phone_outlined,
                ),
                const SizedBox(height: 16),

                // Image Picker Section
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
                                  : 'Change',
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

                // Submit Button
                PrimaryButton(
                  label: 'Publish Lost Item Report',
                  icon: Icons.send_rounded,
                  backgroundColor: AppColors.lostRed,
                  isLoading: _isSubmitting,
                  onPressed: _submitReport,
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
