import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';

import '../../../core/util/extension/app_context_extension.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/bloc/auth_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            // ignore: unnecessary_statements
            : null;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * .2),
              SizedBox(
                height: size.height * .5,
                child: AdaptiveCard(
                  elevation: 2,
                  border: .all(color: theme.colors.dividerColor),
                  backgroundColor: Colors.transparent.withAlpha(1),
                  margin: const .symmetric(horizontal: 16),
                  padding: const .all(16),
                  borderRadius: const .all(.circular(16)),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text('Sign in', style: context.appTheme.typography.h1),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        style: theme.typography.bodyLarge.copyWith(color: theme.colors.onSurface),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.dividerColor),
                          ),
                          focusColor: theme.colors.onSurface,
                          hoverColor: theme.colors.onSurface,
                          fillColor: theme.colors.onSurface,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.onSurface),
                          ),
                          prefixIcon: Icon(Icons.email, color: theme.colors.onSurface),
                          labelText: 'Email',
                          labelStyle: theme.typography.h6.copyWith(color: theme.colors.onSurface),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        style: theme.typography.bodyLarge.copyWith(color: theme.colors.onSurface),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide(color: theme.colors.onSurface),
                          ),
                          focusColor: theme.colors.onSurface,
                          hoverColor: theme.colors.onSurface,
                          fillColor: theme.colors.onSurface,
                          prefixIcon: Icon(Icons.password, color: theme.colors.onSurface),
                          labelText: 'Password',
                          labelStyle: theme.typography.h6.copyWith(color: theme.colors.onSurface),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AdaptiveButton.secondary(
                        sideColor: theme.colors.onSurface,
                        padding: .symmetric(horizontal: size.width * .3, vertical: 16),
                        color: Colors.transparent.withAlpha(1),

                        onPressed: () {
                          bloc.add(
                            AuthSignInRequested(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: theme.typography.h6.copyWith(color: theme.colors.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .15),
              TextButton(
                onPressed: () {
                  context.push('/signin/signup');
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: theme.typography.h6.copyWith(color: theme.colors.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
