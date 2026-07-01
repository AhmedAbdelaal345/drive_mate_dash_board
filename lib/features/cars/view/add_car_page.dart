import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  String _condition = 'Used';
  String _status = 'Published';
  bool _isSaving = false;

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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    final success = await context.read<CarsCubit>().createCar(
          CreateCarRequest(
            brandName: _brandController.text.trim(),
            modelName: _modelController.text.trim(),
          ),
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Car created successfully' : 'Failed to create car',
        ),
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Add Car',
      selectedRoute: RouteNames.cars,
      adminType: widget.adminType,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Car Information',
              children: [
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
                        decoration: const InputDecoration(
                          labelText: 'Brand',
                          hintText: 'e.g. Toyota',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(
                          labelText: 'Model',
                          hintText: 'e.g. Camry',
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          hintText: 'e.g. 2024',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'e.g. \$28,000',
                        ),
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
                              if (val != null) setState(() => _condition = val);
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
                              if (val != null) setState(() => _status = val);
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
                    hintText: 'e.g. Sedan - 2.5L Hybrid',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
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
                      label: _isSaving ? 'Saving...' : 'Publish Car',
                      icon: Icons.publish,
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
}
