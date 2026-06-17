import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_cubit.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSuccessfully) {
          Navigator.pushReplacementNamed(context, RouteNames.dashboard);
        }
      },
      builder: (context, state) {
        final error = state is AuthStateError ? state.error : null;
        final loading = state is AuthStateLoading;

        return Form(
          key: authCubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: authCubit.emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Enter your email address',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter email'
                    : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: authCubit.passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                obscureText: _obscure,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please enter password' : null,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: CustomButton(
                  label: loading ? 'Please wait...' : 'Continue',
                  onPressed: loading
                      ? () {}
                      : () {
                          if (authCubit.formKey.currentState?.validate() ??
                              false) {
                            authCubit.login();
                          }
                        },
                  isPrimary: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
