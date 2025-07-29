import 'dart:convert';
import 'package:docu_sync/constants/colors.dart';
import 'package:docu_sync/screens/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isChecked = false;
  bool _isFormValid = false;

  @override
  // void initState() {
  //   super.initState();
  //   _emailController.addListener(_validateForm);
  //   _phoneController.addListener(_validateForm);
  //   _employeeIdController.addListener(_validateForm);
  //   _passwordController.addListener(_validateForm);
  //   _confirmPasswordController.addListener(_validateForm);
  // }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isFormValid = isValid && _isChecked;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
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
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/sign_up.svg', height: 200,width:200),
                    const SizedBox(height: 10),
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      "Register using your credentials",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "Enter your Email ID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Email is required';
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                              ).hasMatch(value))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Phone',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              hintText: "Enter your Phone No.",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Phone number is required';
                              if (value.length != 10)
                                return 'Enter a valid 10-digit phone number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Employee ID',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _employeeIdController,
                            decoration: const InputDecoration(
                              hintText: "Enter your Employee ID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Employee ID is required'
                                        : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: "Enter password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _passwordVisible = !_passwordVisible,
                                    ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Password is required';
                              if (value.length < 8)
                                return 'Password must be at least 8 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Confirm Password',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Enter password again",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _confirmPasswordVisible =
                                              !_confirmPasswordVisible,
                                    ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please confirm your password';
                              if (value != _passwordController.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (value) {
                                  if (value == true) {
                                  } else {
                                    setState(() {
                                      _isChecked = false;
                                      _validateForm();
                                    });
                                  }
                                },
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: (){},
                                  child: Text.rich(
                                    TextSpan(
                                      text: "I agree with ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                      children: [
                                        TextSpan(
                                          text: "terms & conditions",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                        TextSpan(
                                          text: " and ",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                        ),
                                        TextSpan(
                                          text: "privacy policy",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid
                                ? () {
                                  if (_formKey.currentState!.validate()) {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (context) => ,
                                    //   ),
                                    //);
                                  }
                                }
                                : null,
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.labelMedium,
                          children: [
                            TextSpan(
                              text: "Sign in here",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                            ),
                          ],
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
    );
  }
}
