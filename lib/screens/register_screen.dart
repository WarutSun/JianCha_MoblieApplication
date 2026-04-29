import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  void _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }

    setState(() { _isLoading = true; _error = ''; });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final error = await auth.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful. Please login.')));
      Navigator.of(context).pop();
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
                  Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Join Travel Naja and start booking',
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

                  // Full Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Full Name'),
                  ),
                  SizedBox(height: 12),

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

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                        : ElevatedButton(
                            onPressed: _register,
                            child: Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                  ),
                  SizedBox(height: 16),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('Sign in',
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
