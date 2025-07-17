import 'dart:async'; // Added for StreamSubscription
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:relaxread2/welcome_page.dart';
import '../theme_provider.dart';
import '../services/supabase_client.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required String userName, required String userEmail});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _colors = const {
    'primaryGreen': Color(0xFF6B923C),
    'loginGreen': Color(0xFF5A7F30),
  };
  
  final _supabase = SupabaseService();
  String _name = '', _email = '';
  bool _loading = true;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = _supabase.client.auth.onAuthStateChange.listen(_handleAuthChange);
    _loadUser();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _handleAuthChange(AuthState state) {
    if (state.event == AuthChangeEvent.signedOut && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    }
  }

  Future<void> _loadUser() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) throw Exception('No authenticated user');
      
      final data = await _supabase.getUserData(user.id);

      // ✅ Add null check before accessing data
      if (data == null) {
        throw Exception('User data not found');
      }
      
      if (!mounted) return;
      setState(() {
        _name = data['name'] ?? 'No Name';
        _email = user.email ?? 'No Email';
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showError('Failed to load profile: ${e.toString()}');
      }
    }
  }

  Future<void> _updateName(String newName) async {
    try {
      final user = _supabase.currentUser;
      if (user == null) throw Exception('No authenticated user');
      
      await _supabase.updateName(user.id, newName);
      
      if (!mounted) return;
      setState(() => _name = newName);
      _showMessage('Name updated successfully!');
    } catch (e) {
      if (mounted) _showError('Failed to update name: ${e.toString()}');
    }
  }

  Future<void> _logout() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      if (mounted) _showError('Logout failed: ${e.toString()}');
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) throw Exception('No authenticated user');
      
      await _supabase.deleteUser(user.id);
    } catch (e) {
      if (mounted) _showError('Account deletion failed: ${e.toString()}');
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _updateName(controller.text.trim());
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Account?'),
      content: const Text('All your data will be permanently deleted. This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await _deleteAccount();
          },
          child: const Text('Delete Account'),
        ),
      ],
    ),
  );

  Widget _buildListItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    final theme = Provider.of<ThemeProvider>(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? _colors['primaryGreen']),
        title: Text(
          title, 
          style: TextStyle(
            color: theme.isDarkMode ? Colors.white70 : Colors.grey[800],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: _colors['primaryGreen'],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: _colors['primaryGreen']?.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 80,
                color: _colors['primaryGreen'],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _name, 
                  style: const TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: _colors['primaryGreen'],
                  ),
                  onPressed: _showEditDialog,
                ),
              ],
            ),
            Text(_email),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile Settings', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const Divider(height: 20),
            _buildListItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => showDialog(
                context: context,
                builder: (_) => ChangePasswordDialog(supabase: _supabase),
              ),
            ),
            _buildListItem(
              icon: Icons.subscriptions_outlined,
              title: 'Manage Subscriptions',
              onTap: () => _showMessage('Subscription management coming soon!'),
            ),
            _buildListItem(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              color: Colors.redAccent,
              onTap: _showDeleteDialog,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  final SupabaseService supabase;
  const ChangePasswordDialog({super.key, required this.supabase});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureNew = true, _obscureConfirm = true, _loading = false;

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    try {
      await widget.supabase.updatePassword(_newPassController.text);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
      Navigator.pop(context);
    } on AuthException catch (e) {
      _showError('Authentication error: ${e.message}');
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newPassController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: (value) => 
                value == null || value.isEmpty ? 'Required' : 
                value.length < 6 ? 'Minimum 6 characters' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _confirmPassController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) => 
                value != _newPassController.text ? 'Passwords do not match' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _savePassword,
          child: _loading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}