import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/user_service.dart';

class ManageAccountScreen extends StatefulWidget {
  final bool isTab;
  const ManageAccountScreen({super.key, this.isTab = false});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _first;
  late final TextEditingController _last;
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = UserService.current.value;
    _first = TextEditingController(text: user.firstName);
    _last = TextEditingController(text: user.lastName);
    _username = TextEditingController(text: user.username);
    _email = TextEditingController(text: user.email);
    _phone = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await UserService.updateProfile(
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Account details saved successfully!'),
          ],
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  InputDecoration _dec(BuildContext context, String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: AppColors.textSecondaryOf(context), size: 20),
        filled: true,
        fillColor: AppColors.surfaceOf(context),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text(
          'Manage Account',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        leading: widget.isTab ? null : const BackButton(),
        automaticallyImplyLeading: !widget.isTab,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ValueListenableBuilder<UserProfile>(
            valueListenable: UserService.current,
            builder: (context, user, _) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  // Profile Avatar Header (Solid dominant color, no gradient)
                  _buildProfileCard(context, user),
                  const SizedBox(height: 20),

                  // Personal Information Form
                  _buildInfoCard(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary, // Solid dominant color
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoftOf(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Verified Profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _first,
                    decoration: _dec(context, 'First Name', Icons.badge_outlined),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _last,
                    decoration: _dec(context, 'Last Name', Icons.badge_outlined),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _username,
              decoration: _dec(context, 'Username', Icons.alternate_email),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec(context, 'Email Address', Icons.email_outlined),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Valid email required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: _dec(context, 'Phone Number', Icons.phone_outlined),
              validator: (v) =>
                  (v == null || v.trim().length < 10) ? 'Enter valid phone' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(_saving ? 'Saving...' : 'Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
