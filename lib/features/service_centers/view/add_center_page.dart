import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddCenterPage extends StatefulWidget {
  const AddCenterPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<AddCenterPage> createState() => _AddCenterPageState();
}

class _AddCenterPageState extends State<AddCenterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _servicesController = TextEditingController();

  String _status = 'Operational';

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Add Center',
      selectedRoute: RouteNames.serviceCenters,
      adminType: widget.adminType,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Service Center Details',
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Center Name',
                    hintText: 'e.g. Dubai Main Workshop',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          hintText: 'e.g. Dubai',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'e.g. +971 50 123 4567',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Address / Location',
                    hintText: 'e.g. Al Quoz Industrial Area 3',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Operational Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomDropDown<String>(
                      value: _status,
                      items: const ['Operational', 'Closed'],
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _servicesController,
                  decoration: const InputDecoration(
                    labelText: 'Services Provided (comma-separated)',
                    hintText: 'e.g. Oil Change, Tires, Engine Tuning',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
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
                      label: 'Add Center',
                      icon: Icons.check,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final success = await context
                              .read<ServiceCentersCubit>()
                              .createCenter(
                                name: _nameController.text.trim(),
                                address:
                                    '${_locationController.text.trim()}, ${_cityController.text.trim()}',
                                latitude: 30.0444,
                                longitude: 31.2357,
                                phone: _phoneController.text.trim(),
                              );
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Service center added successfully'),
                              ),
                            );
                            Navigator.pop(context);
                          }
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
}
