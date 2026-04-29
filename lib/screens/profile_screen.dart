import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _api = ApiService();
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String _error = '';
  String _success = '';

  Map<String, dynamic> _profile = {};
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.get('/users/profile');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _profile = data;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
        });
      }
    } catch (e) {
      setState(() => _error = 'Failed to load profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() { _isSaving = true; _error = ''; _success = ''; });

    try {
      final body = <String, dynamic>{
        'name': _nameController.text,
      };

      final response = await _api.put('/users/profile', body);
      if (response.statusCode == 200) {
        setState(() {
          _success = 'Profile updated successfully!';
          _isEditing = false;
        });
        // Update name in auth provider
        final auth = Provider.of<AuthProvider>(context, listen: false);
        auth.updateName(_nameController.text);
        _fetchProfile();
      } else {
        final data = jsonDecode(response.body);
        setState(() => _error = data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      setState(() => _error = 'Failed to connect to server');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),

              // Messages
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
                SizedBox(height: 12),
              ],
              if (_success.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF22C55E).withValues(alpha: 0.1),
                    border: Border.all(color: Color(0xFF22C55E)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_success, style: TextStyle(color: Color(0xFF22C55E), fontSize: 14)),
                ),
                SizedBox(height: 12),
              ],

              // Profile Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(0xFF262626),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, size: 32, color: Color(0xFFA3A3A3)),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_profile['name'] ?? 'User',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text(_profile['email'] ?? '',
                                    style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF262626),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    auth.role == 'staff' ? '👨‍💼 Staff' : '👤 Member',
                                    style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (!_isEditing) ...[
                        SizedBox(height: 20),
                        // Info rows
                        Divider(),
                        _infoRow('Name', _profile['name'] ?? ''),
                        _infoRow('Email', _profile['email'] ?? ''),
                        _infoRow('Role', (_profile['role'] ?? 'member').toString().toUpperCase()),
                        _infoRow('Member Since', _profile['created_at']?.toString().split('T')[0] ?? ''),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Edit Form
              if (_isEditing) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),

                        Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        TextField(controller: _nameController, decoration: InputDecoration(hintText: 'Full Name')),
                        SizedBox(height: 12),

                        Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                        ),
                        SizedBox(height: 4),
                        Text('Email cannot be changed', style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12)),
                        SizedBox(height: 20),

                        // Save / Cancel buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  child: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton(
                                  onPressed: _isSaving ? null : () {
                                    setState(() {
                                      _isEditing = false;
                                      _error = '';
                                      _nameController.text = _profile['name'] ?? '';
                                      _emailController.text = _profile['email'] ?? '';
                                    });
                                  },
                                  child: Text('Cancel'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Edit button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => setState(() { _isEditing = true; _success = ''; }),
                    child: Text('✏️ Edit Profile'),
                  ),
                ),
              ],

              SizedBox(height: 16),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFEF4444)),
                    foregroundColor: Color(0xFFEF4444),
                  ),
                  child: Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }
}
