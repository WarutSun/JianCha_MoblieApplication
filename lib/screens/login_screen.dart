import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }

    setState(() { _isLoading = true; _error = ''; });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final error = await auth.login(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (error == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainNavigationScreen()));
    } else {
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Sign in to your Travel Naja account',
                      style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                  SizedBox(height: 24),

                  // Error
                  if (_error.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444).withValues(alpha: 0.1),
                        border: Border.all(color: Color(0xFFEF4444)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_error, style: TextStyle(color: Color(0xFFEF4444), fontSize: 14)),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),

                  // Password
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 24),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                        : ElevatedButton(
                            onPressed: _login,
                            child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                  ),
                  SizedBox(height: 16),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreen())),
                        child: Text('Sign up',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ],
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
