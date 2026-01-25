import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/gradient_background.dart';

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
    final theme = context.appTheme;
    final bloc = DependScope.of(context).dependModel.authBloc;
    final size = MediaQuery.sizeOf(context);
    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listener: (context, state) {
        state is AuthError
            ? ScaffoldMessenger.of(context).showSnackBar(
                appFlavor!.contains('dev')
                    ? SnackBar(content: Text(state.errorMessage))
                    : SnackBar(content: Text('autg Failed')),
              )
            : null;
      },

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * .2),
              SizedBox(
                height: size.height * .5,
                child: AdaptiveCard(
                  elevation: 2,
                  border: Border.all(color: theme.colors.surface),
                  backgroundColor: theme.colors.cardBackground.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign in',
                        style: theme.typography.h1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: theme.colors.textPrimary),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.surface),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.surface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.primary),
                          ),
                          prefixIcon: Icon(Icons.email, color: theme.colors.textSecondary),
                          labelText: 'Email',
                          labelStyle: theme.typography.h6.copyWith(
                            color: theme.colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: theme.colors.textPrimary),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.surface),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.surface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colors.primary),
                          ),
                          prefixIcon: Icon(Icons.password, color: theme.colors.textSecondary),
                          labelText: 'Password',
                          labelStyle: theme.typography.h6.copyWith(
                            color: theme.colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AdaptiveButton.secondary(
                        sideColor: theme.colors.primary,
                        padding: EdgeInsets.symmetric(horizontal: size.width * .3, vertical: 16),
                        color: theme.colors.primary,
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
                          style: TextStyle(color: theme.colors.onPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  'Don\'t have an account? Sign up',
                  style: theme.typography.h6.copyWith(color: theme.colors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
