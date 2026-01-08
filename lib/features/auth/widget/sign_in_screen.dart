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
      child: AnimatedBackground(
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
                    border: .all(color: ColorConstants.duskPurple),
                    backgroundColor: Colors.transparent.withAlpha(1),
                    margin: .symmetric(horizontal: 16),
                    padding: .all(16),
                    borderRadius: .all(.circular(16)),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Text('Sign in', style: context.appTheme.typography.h1),
                        SizedBox(height: 24),
                        TextField(
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
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            labelText: 'Email',
                            labelStyle: theme.typography.h6,
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: .circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: .circular(16),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.white,
                            ),
                            labelText: 'Password',
                            labelStyle: theme.typography.h6,
                          ),
                        ),
                        SizedBox(height: 24),
                        AdaptiveButton.secondary(
                          sideColor: Colors.white,
                          padding: .symmetric(
                            horizontal: size.width * .3,
                            vertical: 16,
                          ),
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
                    context.push('/signin/signup');
                  },
                  child: Text(
                    'Don\'t have an account? Sign up',
                    style: theme.typography.h6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
