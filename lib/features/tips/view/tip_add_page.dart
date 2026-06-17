import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_drop_down.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class TipAddPage extends StatefulWidget {
  const TipAddPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<TipAddPage> createState() => _TipAddPageState();
}

class _TipAddPageState extends State<TipAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();

  String _difficulty = 'Easy';
  String _status = 'Published';

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
      title: 'Add Tip',
      selectedRoute: RouteNames.tips,
      adminType: widget.adminType,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormSection(
              title: 'Tip Details',
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tip Title',
                    hintText: 'e.g. Coolant Level Check (Vol. 2)',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'e.g. Fuel Efficiency',
                        ),
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
                          hintText: 'e.g. 7 mins',
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
                      label: 'Publish Tip',
                      icon: Icons.publish,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tip published successfully (Mock)'),
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
