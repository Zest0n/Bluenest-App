import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _bgAsset = 'assets/images/welcome_bg.jpg';

  void _open(BuildContext context, String role) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AuthScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Background: always fills the whole screen, any size/orientation.
          //    BoxFit.cover scales + crops instead of stretching.
          //    If the asset is ever missing, a dark gradient shows instead of
          //    the red error box.
          Image.asset(
            _bgAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.secondary, AppColors.midnight],
                ),
              ),
            ),
          ),

          // 2) Dark overlay so the text is readable on any photo
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.midnight.withOpacity(0.60),
                  AppColors.midnight.withOpacity(0.20),
                ],
              ),
            ),
          ),

          // 3) Content - scrolls on very short screens, never overflows
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final h = c.maxHeight;
                final logo = (h * 0.09).clamp(44.0, 80.0);
                final title = (h * 0.05).clamp(28.0, 42.0);

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: h),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.home_rounded,
                                        size: logo, color: AppColors.primary),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      child: Text(
                                        'BLUENEST',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: title,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: title * 0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Find your place. Feel at home.',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Bottom sheet: full width on phones, centred &
                          // capped at 480px on tablets / web.
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: _RoleSheet(onSelect: (r) => _open(context, r)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleSheet extends StatelessWidget {
  final void Function(String role) onSelect;
  const _RoleSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How will you use BlueNest?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _RoleCard(
            icon: Icons.search_rounded,
            title: "I'm looking for a home",
            subtitle: 'Explore rentals, manage rent and raise issues.',
            onTap: () => onSelect('tenant'),
          ),
          const SizedBox(height: 14),
          _RoleCard(
            icon: Icons.apartment_rounded,
            title: 'I manage properties',
            subtitle: 'List properties, manage tenants and maintenance.',
            onTap: () => onSelect('landlord'),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primarySoft,
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
