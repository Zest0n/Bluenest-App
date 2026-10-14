import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role; // 'tenant' or 'landlord'
  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _loading = false;
  bool _hidePass = true;

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();

  @override
  void dispose() {
    for (final c in [_username, _email, _phone, _first, _last, _pass, _pass2]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toast(String msg, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    String? error;
    if (_isLogin) {
      error = await AuthService.login(
        username: _username.text.trim(),
        password: _pass.text,
        role: widget.role,
      );
    } else {
      error = await AuthService.register(
        username: _username.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        firstName: _first.text.trim(),
        lastName: _last.text.trim(),
        password: _pass.text,
        password2: _pass2.text,
        role: widget.role,
      );
    }

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      _toast(error);
      return;
    }

    if (_isLogin) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(role: widget.role)),
        (_) => false,
      );
    } else {
      _toast('Account created! Please log in.', error: false);
      setState(() => _isLogin = true);
    }
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
      );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final isTenant = widget.role == 'tenant';
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLogin ? 'Welcome back' : 'Create account',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  isTenant ? 'Continuing as a tenant' : 'Continuing as a landlord',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                if (!_isLogin) ...[
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                            controller: _first,
                            decoration: _dec('First name', Icons.person_outline),
                            validator: _required)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextFormField(
                            controller: _last,
                            decoration: _dec('Last name', Icons.person_outline),
                            validator: _required)),
                  ]),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                    controller: _username,
                    decoration: _dec('Username', Icons.alternate_email),
                    validator: _required),
                const SizedBox(height: 14),
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dec('Email', Icons.email_outlined),
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: _dec('Phone', Icons.phone_outlined),
                    validator: (v) =>
                        (v == null || v.trim().length < 10) ? 'Enter a valid phone' : null,
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _pass,
                  obscureText: _hidePass,
                  decoration: _dec('Password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 8) ? 'Min 8 characters' : null,
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _pass2,
                    obscureText: _hidePass,
                    decoration: _dec('Confirm password', Icons.lock_outline),
                    validator: (v) =>
                        v != _pass.text ? 'Passwords do not match' : null,
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(_isLogin ? 'Log in' : 'Sign up',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                    }),
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Sign up"
                          : 'Already have an account? Log in',
                      style: const TextStyle(color: AppColors.secondary),
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
