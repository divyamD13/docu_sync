import 'package:docu_sync/constants/colors.dart';
import 'package:docu_sync/models/error_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:docu_sync/screens/home_screen.dart';
import 'package:docu_sync/screens/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final double webWidth = MediaQuery.of(context).size.width * 0.3;
  late final double mobileWidth = MediaQuery.of(context).size.width * 0.6;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _signInWithEmailPassword() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      print('Logging in with: $email, $password');
    }
  }
  

  void _signInWithGoogle() async{
    final errorModel = await ref.watch(authRepositoryProvider).signInWithGoogle();
    if(errorModel!=null){
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorModel.error ?? 'Sign-in failed')),
      );
    }
    print('Google Sign-In triggered');
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/log_in.svg',
                  height: 200,
                  width: 200,
                ),
      
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
                      child: SizedBox(
                        width: kIsWeb ? webWidth : mobileWidth,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  );
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
                                  border: OutlineInputBorder(
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
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val ?? false;
                                      });
                                    },
                                  ),
                                  const Text("Remember me"),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ForgotPasswordScreen(),
                                      //   ),
                                      // );
                                    },
                                    child: const Text("Forgot password?"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: _signInWithEmailPassword,
                                    child: const Text("Log In"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                        );
                                  },
                                  child: RichText(
                                                        text: TextSpan(
                                                          text: "Don't have an account? ",
                                                          style: Theme.of(context).textTheme.labelMedium,
                                                          children: [
                                                            TextSpan(
                                text: "Register Here",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                      );
                                      print('Register here tapped');
                                    },
                                  ),
                                ],                    ),
                                ),
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 40,
                  width: kIsWeb ? webWidth * 0.7 : mobileWidth,
                  child: OutlinedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Image.asset('assets/images/g-logo.png', height: 30),
                    label: const Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
