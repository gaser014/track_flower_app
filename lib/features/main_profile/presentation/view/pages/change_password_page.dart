import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/config/api/end_points.dart';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:gap/gap.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get _isFormValid {
    return _currentPasswordController.text.trim().isNotEmpty &&
           _newPasswordController.text.trim().isNotEmpty &&
           _confirmPasswordController.text.trim().isNotEmpty;
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_onFieldChanged);
    _newPasswordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = getIt.get<Dio>();
      await dio.put(
        EndPoints.changePassword,
        data: {
          'currentPassword': _currentPasswordController.text,
          'password': _newPasswordController.text,
          'passwordConfirm': _confirmPasswordController.text,
        },
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response?.data?['message'] ?? 'Invalid password';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label, {bool isError = false}) {
    final borderColor = isError ? Colors.red : AppColors.grayA6;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isError ? Colors.red : AppColors.grayA6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isError ? Colors.red : AppColors.primerColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reset password', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: _inputDecoration('Current password', isError: _errorMessage != null),
              ),
              if (_errorMessage != null) ...[
                const Gap(4),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const Gap(16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: _inputDecoration('New password'),
              ),
              const Gap(16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration('Confirm password'),
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray7D,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  onPressed: (_isLoading || !_isFormValid) ? null : _updatePassword,
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) 
                      : const Text('Update', style: TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
