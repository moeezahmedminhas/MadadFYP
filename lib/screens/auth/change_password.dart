import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad_final/api/apis.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  void _toggleObscureOldPassword() {
    setState(() {
      _isObscureOldPassword = !_isObscureOldPassword;
    });
  }

  void _toggleObscureNewPassword() {
    setState(() {
      _isObscureNewPassword = !_isObscureNewPassword;
    });
  }

  void _toggleObscureConfirmPassword() {
    setState(() {
      _isObscureConfirmPassword = !_isObscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _isObscureOldPassword,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleObscureOldPassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Please enter your old password';
                    }
                    // TODO: Add validation for old password here.
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _isObscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleObscureNewPassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Please enter a new password';
                    } else if (value == _oldPasswordController.text) {
                      return 'current Password and new password cannot be same';
                    }
                    // TODO: Add validation for new password here.
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _isObscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleObscureConfirmPassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await APIs.auth.currentUser!
                            .updatePassword(_newPasswordController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password changed successfully!'),
                          ),
                        );
                        Navigator.of(context).pop();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('The password provided is too weak.'),
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password changed successfully!'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
