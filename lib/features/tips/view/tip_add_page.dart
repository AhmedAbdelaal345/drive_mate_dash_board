import 'dart:io';
import 'dart:typed_data';

import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/form_section.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_cubit.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TipAddPage extends StatefulWidget {
  const TipAddPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<TipAddPage> createState() => _TipAddPageState();
}

class _TipAddPageState extends State<TipAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _image;
  Uint8List? _imageBytes;
  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = image;
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TipsCubit>(context),
      child: DashboardShell(
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_imageBytes != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _imageBytes!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      CustomButton(
                        label: _image == null ? 'Select Image' : 'Change Image',
                        icon: Icons.image_outlined,
                        isPrimary: false,
                        onPressed: _pickImage,
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text(
                  //             'Difficulty Level',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.w600,
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //           const SizedBox(height: 8),
                  //           CustomDropDown<String>(
                  //             value: _difficulty,
                  //             items: const ['Easy', 'Medium', 'Hard'],
                  //             onChanged: (val) {
                  //               if (val != null) {
                  //                 setState(() {
                  //                   _difficulty = val;
                  //                 });
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text(
                  //             'Publication Status',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.w600,
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //           const SizedBox(height: 8),
                  //           CustomDropDown<String>(
                  //             value: _status,
                  //             items: const ['Published', 'Draft'],
                  //             onChanged: (val) {
                  //               if (val != null) {
                  //                 setState(() {
                  //                   _status = val;
                  //                 });
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  BlocConsumer<TipsCubit, TipsState>(
                    bloc: BlocProvider.of<TipsCubit>(context),
                    listener: (context, state) {
                      if (state is TipsError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                      if (state is TipCreateSuccess) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is TipsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Row(
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
                                context.read<TipsCubit>().createTip(
                                  title: _titleController.text,
                                  content: _contentController.text,
                                  image: File(_image!.path),
                                  category: _categoryController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
