import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../../../../core/services/local_profile_service.dart';
import '../../../text_extraction/presentation/pages/main_navigation_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpRequested(email: _emailController.text.trim(), password: _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            LocalProfileService().saveDisplayName(_nameController.text.trim());
            Navigator.of(
              context,
            ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainNavigationPage()), (route) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    Image.asset('assets/images/logo2.png', height: 130, fit: BoxFit.contain),
                    const SizedBox(height: 15),

                    const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.validateEmail,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    PasswordTextField(controller: _passwordController, enabled: !isLoading),
                    const SizedBox(height: 16),

                    PasswordTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      enabled: !isLoading,
                      validator: (value) => Validators.validateConfirmPassword(_passwordController.text, value),
                    ),
                    const SizedBox(height: 24),

                    CustomButton(text: 'Sign Up', isLoading: isLoading, onPressed: _signUp),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(context, '/signin');
                                },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
