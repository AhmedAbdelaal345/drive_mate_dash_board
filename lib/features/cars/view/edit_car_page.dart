import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _hasImage = true;
  bool _isUploading = false;
  bool _isSaving = false;
  int _carId = 0;
  int _brandId = 0;

  @override
  void initState() {
    super.initState();

    final args = widget.carId;
    final map = args is Map ? args : <String, Object?>{};
    _carId = _readInt(map['id']);
    _brandId = _readInt(map['brandId']);
    final brand = map['brand']?.toString() ?? 'Toyota';
    final model = map['model']?.toString() ?? 'Camry';

    _nameController = TextEditingController(text: '$brand $model'.trim());
    _brandController = TextEditingController(text: brand);
    _modelController = TextEditingController(text: model);
    _yearController = TextEditingController(text: '2024');
    _priceController = TextEditingController(text: '\$28,000');
    _descController = TextEditingController(text: model);
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

  int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_carId == 0 || _brandId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing car id or brand id')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final success = await context.read<CarsCubit>().updateCar(
          id: _carId,
          request: UpdateCarRequest(
            brandId: _brandId,
            modelName: _modelController.text.trim(),
          ),
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Car updated successfully' : 'Failed to update car',
        ),
      ),
    );

    if (success) Navigator.pop(context);
  }

  void _simulateUpload() {
    setState(() => _isUploading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        _hasImage = true;
      });
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
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brandController,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Brand'),
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
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDown<String>(
                        value: _condition,
                        items: const ['New', 'Used'],
                        onChanged: (val) {
                          if (val != null) setState(() => _condition = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropDown<String>(
                        value: _status,
                        items: const ['Published', 'Draft', 'Sold'],
                        onChanged: (val) {
                          if (val != null) setState(() => _status = val);
                        },
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
                      label: _isSaving ? 'Saving...' : 'Save Changes',
                      icon: Icons.save,
                      onPressed: _isSaving ? () {} : _submit,
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
      return _PhotoBox(
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.teal),
        ),
      );
    }

    if (_hasImage) {
      return _PhotoBox(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 48, color: Colors.blue.shade300),
                  const SizedBox(height: 8),
                  const Text(
                    'vehicle-image.jpg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () => setState(() => _hasImage = false),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _simulateUpload,
      borderRadius: BorderRadius.circular(12),
      child: const _PhotoBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.teal),
            SizedBox(height: 10),
            Text(
              'Upload Vehicle Image',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
