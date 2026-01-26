import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/gradient_background.dart';

import '../../../core/util/extension/app_context_extension.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/bloc/auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final AuthBloc bloc = DependScope.of(context).dependModel.authBloc;
    final Size size = MediaQuery.sizeOf(context);
    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listener: (context, state) {
        state is AuthError
            ? ScaffoldMessenger.of(context).showSnackBar(
                appFlavor!.contains('dev')
                    ? SnackBar(content: Text(state.errorMessage))
                    : const SnackBar(content: Text('autg Failed')),
              )
            : null;
      },
      child: AnimatedBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * .2),
                  SizedBox(
                    height: size.height * .5,
                    child: AdaptiveCard(
                      elevation: 2,
                      border: .all(color: ColorConstants.duskPurple),
                      backgroundColor: Colors.transparent.withAlpha(1),
                      margin: const .symmetric(horizontal: 16),
                      padding: const .all(16),
                      borderRadius: const .all(.circular(16)),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            'Sign up',
                            style: context.appTheme.typography.h1,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!val.contains('@')) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: .circular(16),
                              ),
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: .circular(16),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              labelText: 'Email',
                              labelStyle: theme.typography.h6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter password';
                              }
                              if (val.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: .circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: .circular(16),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              labelText: 'Password',
                              labelStyle: theme.typography.h6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'confirm password';
                              }
                              if (val != _passwordController.text) {
                                return 'password not match';
                              }
                              return null;
                            },
                            controller: _confirmPasswordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: .circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: .circular(16),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _toggle();
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),

                              labelText: 'Confirm Password',
                              labelStyle: theme.typography.h6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AdaptiveButton.secondary(
                            sideColor: Colors.white,
                            padding: .symmetric(
                              horizontal: size.width * .3,
                              vertical: 16,
                            ),
                            color: Colors.transparent.withAlpha(1),

                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              bloc.add(
                                AuthSignUpRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * .15),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Have an account? Sign in',
                      style: theme.typography.h6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
