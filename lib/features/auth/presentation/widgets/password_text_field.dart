import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import 'custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool enabled;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.enabled = true,
    this.validator = Validators.validatePassword,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscure,
      prefixIcon: Icons.lock_outline,
      enabled: widget.enabled,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
