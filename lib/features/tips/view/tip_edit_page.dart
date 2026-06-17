import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class TipEditPage extends StatefulWidget {
  const TipEditPage({super.key, required this.adminType, this.itemId});

  final AdminType adminType;
  final Object? itemId;

  @override
  State<TipEditPage> createState() => _TipEditPageState();
}

class _TipEditPageState extends State<TipEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _durationController;

  String _difficulty = 'Medium';
  String _status = 'Published';

  @override
  void initState() {
    super.initState();
    // Resolve prefilled values
    final String tipTitle =
        (widget.itemId is Map)
            ? (widget.itemId as Map)['id']?.toString() ?? 'Emergency Kit Essentials (Vol. 2)'
            : widget.itemId?.toString() ?? 'Emergency Kit Essentials (Vol. 2)';

    _titleController = TextEditingController(text: tipTitle);
    _categoryController = TextEditingController(text: 'Driving Tips');
    _durationController = TextEditingController(text: '36 mins');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Edit Tip',
      selectedRoute: RouteNames.tips,
      adminType: widget.adminType,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Edit Tip Details',
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Tip Title'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required field'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: 'Reading Time / Duration',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Difficulty Level',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropDown<String>(
                            value: _difficulty,
                            items: const ['Easy', 'Medium', 'Hard'],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _difficulty = val;
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
                            'Publication Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropDown<String>(
                            value: _status,
                            items: const ['Published', 'Draft'],
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
