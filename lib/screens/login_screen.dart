import 'package:docu_sync/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailPassword() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      print('Logging in with: $email, $password');
    }
  }

  void _signInWithGoogle() async {
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      Routemaster.of(context).replace('/');
    } else {
      if (mounted) {
        print('Google Sign-In failed: ${errorModel.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorModel.error ?? 'Sign-in failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 121, 107, 1),
            Color.fromRGBO(142, 196, 196, 1),
            Color.fromRGBO(255, 255, 255, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/log_in.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email Address',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: "Enter your Email address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex =
                                      RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Password',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: "Enter your Password",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: _signInWithEmailPassword,
                                  child: const Text("Log In"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: SizedBox(
                      height: 45,
                      width: screenWidth,
                      child: OutlinedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Image.asset('assets/images/g-logo.png',
                            height: 24),
                        label: const Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
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