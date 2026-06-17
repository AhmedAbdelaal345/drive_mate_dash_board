import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class EditCenterPage extends StatefulWidget {
  const EditCenterPage({super.key, required this.adminType, this.centerId});

  final AdminType adminType;
  final Object? centerId;

  @override
  State<EditCenterPage> createState() => _EditCenterPageState();
}

class _EditCenterPageState extends State<EditCenterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _servicesController;

  String _status = 'Operational';

  @override
  void initState() {
    super.initState();
    // Resolve dummy pre-filled values
    final String centerName =
        (widget.centerId is Map)
            ? (widget.centerId as Map)['id']?.toString() ?? 'Dubai Main Workshop'
            : widget.centerId?.toString() ?? 'Dubai Main Workshop';

    _nameController = TextEditingController(text: centerName);
    _cityController = TextEditingController(text: 'Dubai');
    _locationController = TextEditingController(text: 'Al Quoz Industrial Area 3');
    _phoneController = TextEditingController(text: '+971 50 123 4567');
    _servicesController = TextEditingController(text: 'Oil Change, Tires, Engine');
  }

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
      title: 'Edit Center',
      selectedRoute: RouteNames.serviceCenters,
      adminType: widget.adminType,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Edit Service Center Details',
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Center Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
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
}
