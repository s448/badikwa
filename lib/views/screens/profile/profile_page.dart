import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:prufcoach/core/localStorage/user_storage.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/data/auth_data.dart';
import 'package:prufcoach/views/screens/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hasChanges = false;
  bool _editingPassword = false;
  bool _isSaving = false; // <-- new saving state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await UserStorage.getFullName();
    final email = await UserStorage.getEmail();
    log("Loaded name: ${name ?? "none"}");
    log("Loaded email: ${email ?? "none"}");

    setState(() {
      _nameController.text = name ?? "";
      _emailController.text = email ?? "";
      _passwordController.text = "••••••";
    });
  }

  void _markChanged() {
    setState(() => _hasChanges = true);
  }

  bool _isPasswordValid(String value) {
    final hasMinLength = value.length >= 6;
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    return hasMinLength && hasDigit;
  }

  Future<void> _saveChanges() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.placeholderText,
            title: const Text("Confirm Changes"),
            content: const Text("Are you sure you want to save changes?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColors.primaryGreen,
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  "Yes, Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    setState(() {
      _isSaving = true; // show indicator
    });

    try {
      final userId = await UserStorage.getUserId();
      if (userId == null) return;

      // save name locally
      await UserStorage.saveUserData(
        userId,
        _nameController.text,
        _emailController.text,
      );

      // if password was changed and valid → update server
      if (_editingPassword && _isPasswordValid(_passwordController.text)) {
        try {
          await AuthData().resetPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
          log("Password updated successfully");
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating password: $e")),
          );
          return;
        }
      }

      if (!mounted) return;

      setState(() {
        _hasChanges = false;
        _editingPassword = false;
        _passwordController.text = "••••••••";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Changes saved successfully!")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false; // hide indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Image.asset(
                    'assets/icons/profile_ic.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),

                // Editable Name
                _buildProfileField(
                  label: "Name",
                  controller: _nameController,
                  editable: true,
                  onChanged: (_) => _markChanged(),
                ),

                // Non-editable Email
                _buildProfileField(
                  label: "E-Mail-Adresse",
                  controller: _emailController,
                  editable: false,
                ),

                // Editable password with dots
                _buildPasswordField(),

                const SizedBox(height: 30),

                if (_hasChanges)
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await AuthData().signOut();
                    if (!mounted) return;
                    pushScreenWithoutNavBar(context, LoginPage());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Overlay saving indicator without modifying underlying UI
          if (_isSaving)
            Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 25,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool editable,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: !editable,
            onChanged: editable ? onChanged : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Passwort",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            onTap: () {
              if (!_editingPassword) {
                setState(() {
                  _editingPassword = true;
                  _passwordController.clear();
                });
              }
            },
            onChanged: (value) {
              if (_isPasswordValid(value)) {
                _markChanged();
              }
            },
            decoration: InputDecoration(
              hintText: _editingPassword ? "Enter new password" : null,
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
