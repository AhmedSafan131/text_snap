import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/services/local_profile_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    try {
      final localProfileService = LocalProfileService();

      final localName = localProfileService.getDisplayName();
      final localImage = localProfileService.getProfileImagePath();

      setState(() {
        if (localImage != null) {
          _selectedImagePath = localImage;
        }

        if (localName != null && localName.isNotEmpty) {
          _nameController.text = localName;
        } else {
          final state = context.read<AuthBloc>().state;
          if (state is Authenticated) {
            _nameController.text = state.user.displayName ?? '';
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final localProfileService = LocalProfileService();

      if (_selectedImagePath != null) {
        await localProfileService.saveProfileImagePath(_selectedImagePath!);
      }

      final newName = _nameController.text.trim();
      if (newName.isNotEmpty) {
        await localProfileService.saveDisplayName(newName);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved'), backgroundColor: AppColors.success));

        Navigator.pop(context, true); // Return true to signal update
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save profile: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), elevation: 0),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final email = (state is Authenticated) ? state.user.email : '';
          final authName = (state is Authenticated) ? state.user.displayName : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          image: _selectedImagePath != null
                              ? DecorationImage(image: FileImage(File(_selectedImagePath!)), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _selectedImagePath == null
                            ? Center(
                                child: Text(
                                  authName?.isNotEmpty == true
                                      ? authName![0].toUpperCase()
                                      : (email.isNotEmpty ? email[0].toUpperCase() : '?'),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: _pickImage,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _pickImage, child: const Text('Change Photo')),
                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Display Name',
                    hint: 'Enter your name',
                    prefixIcon: Icons.person_outline,
                    validator: Validators.validateName,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(email, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  CustomButton(text: 'Save', isLoading: _isLoading, onPressed: _saveProfile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
