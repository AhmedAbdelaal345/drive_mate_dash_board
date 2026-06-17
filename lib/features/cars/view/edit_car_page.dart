import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class EditCarPage extends StatefulWidget {
  const EditCarPage({super.key, required this.adminType, this.carId});

  final AdminType adminType;
  final Object? carId;

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _descController;

  String _condition = 'Used';
  String _status = 'Published';

  // Mock Photo Uploader state
  bool _hasImage = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with dummy values based on ID or default values
    final String carName =
        (widget.carId is Map)
            ? (widget.carId as Map)['id']?.toString() ?? 'Toyota Camry 2024'
            : widget.carId?.toString() ?? 'Toyota Camry 2024';

    _nameController = TextEditingController(text: carName);
    _brandController = TextEditingController(text: 'Toyota');
    _modelController = TextEditingController(text: 'Camry');
    _yearController = TextEditingController(text: '2024');
    _priceController = TextEditingController(text: '\$28,000');
    _descController = TextEditingController(text: 'Sedan - 2.5L Hybrid');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _hasImage = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mock Image uploaded successfully!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Edit Car',
      selectedRoute: RouteNames.cars,
      adminType: widget.adminType,
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Edit Car Details',
              children: [
                // PHOTO UPLOADER BOX
                const Text(
                  'Vehicle Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPhotoUploader(),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Car Name / Title',
                    hintText: 'e.g. Toyota Camry 2024',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brandController,
                        decoration: const InputDecoration(labelText: 'Brand'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(labelText: 'Model'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(labelText: 'Year'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Condition',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropDown<String>(
                            value: _condition,
                            items: const ['New', 'Used'],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                    _condition = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropDown<String>(
                            value: _status,
                            items: const ['Published', 'Draft', 'Sold'],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _status = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description / Specs',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      label: 'Cancel',
                      icon: Icons.close,
                      isPrimary: false,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      label: 'Save Changes',
                      icon: Icons.save,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Changes saved successfully (Mock)'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploader() {
    if (_isUploading) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(strokeWidth: 3, color: AppColors.teal),
              SizedBox(height: 12),
              Text(
                'Uploading image...',
                style: TextStyle(fontSize: 13, color: AppColors.muted, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasImage) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            // Center mockup preview image
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 48, color: Colors.blue.shade300),
                  const SizedBox(height: 8),
                  const Text(
                    'toyota-camry-2024.jpg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                      fontSize: 13,
                    ),
                  ),
                  const Text(
                    '1.2 MB • Ready',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            // Delete badge at top right
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Delete image',
                  icon: const Icon(Icons.delete_forever, color: Colors.white, size: 18),
                  onPressed: () {
                    setState(() {
                      _hasImage = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state - clickable container
    return InkWell(
      onTap: _simulateUpload,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.teal.withValues(alpha: 0.5),
            style: BorderStyle.solid, // dashed border simulated using borders + decoration
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.teal),
            const SizedBox(height: 10),
            const Text(
              'Upload Vehicle Image',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Supports JPG, PNG, WEBP up to 5MB',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
