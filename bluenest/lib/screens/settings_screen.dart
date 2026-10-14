import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_navigator.dart';
import '../core/app_theme.dart';
import '../core/support.dart';
import '../services/user_service.dart';
import 'manage_account_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String role; // 'tenant' or 'landlord'
  final bool isTab;

  const SettingsScreen({
    super.key,
    this.role = 'tenant',
    this.isTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLandlord = role == 'landlord';
    final roleLabel = isLandlord ? 'Landlord' : 'Resident';

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        automaticallyImplyLeading: !isTab,
        leading: isTab ? null : const BackButton(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ValueListenableBuilder<UserProfile>(
            valueListenable: UserService.current,
            builder: (context, user, _) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // Profile Overview Header Card
                  _buildProfileHeader(context, user, roleLabel),
                  const SizedBox(height: 20),

                  // Account Settings Card
                  _buildSectionHeader(context, 'Account'),
                  const SizedBox(height: 8),
                  _buildAccountCard(context),
                  const SizedBox(height: 20),

                  // Theme / Dark UI Card
                  _buildSectionHeader(context, 'Appearance & Theme'),
                  const SizedBox(height: 8),
                  _buildThemeCard(context),
                  const SizedBox(height: 20),

                  // Support & Legal Card
                  _buildSectionHeader(context, 'Support & Help'),
                  const SizedBox(height: 8),
                  _buildSupportCard(context, roleLabel),
                  const SizedBox(height: 24),

                  // Log Out Button
                  _buildLogoutButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryOf(context),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, UserProfile user, String roleLabel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          // Solid dominant color avatar (No gradient per rule)
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    fontSize: 13,
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
                  child: Text(
                    roleLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySoftOf(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.manage_accounts_rounded,
                color: AppColors.primary, size: 20),
          ),
          title: Text(
            'Manage Account',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          subtitle: Text(
            'Edit your name, username, email & phone',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.primary),
          onTap: () {
            AppNavigator.push(context, const ManageAccountScreen());
          },
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: SwitchListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF312E81)
                      : AppColors.primarySoftOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: isDark ? const Color(0xFFA5B4FC) : AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              subtitle: Text(
                isDark ? 'Aesthetic Dark UI active' : 'Clean Light UI active',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              activeThumbColor: AppColors.primary,
              activeTrackColor: const Color(0xFF6366F1),
              value: isDark,
              onChanged: (_) => AppTheme.toggleTheme(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportCard(BuildContext context, String roleLabel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.support_agent_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              subtitle: Text(
                'Email support@bluenest.app',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.primary),
              onTap: () => SupportMailer.open(
                context,
                subject: 'BlueNest Support ($roleLabel)',
              ),
            ),
            Divider(height: 1, indent: 64, color: AppColors.borderOf(context)),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Terms & Privacy Policy',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              subtitle: Text(
                'BlueNest User Agreement & Privacy Policy',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.primary),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('BlueNest Terms & Privacy Policy v1.0'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: OutlinedButton.icon(
        onPressed: () => AppNavigator.logout(context),
        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.danger),
        label: const Text(
          'Log Out of BlueNest',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
