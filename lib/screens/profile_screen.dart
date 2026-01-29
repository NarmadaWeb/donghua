import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      // Should not happen if guarded, but for safety
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            child: const Text("Login"),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            // If pushed from somewhere, pop. If in tab, maybe switch tab?
            // In bottom nav, back usually does nothing or exits.
          },
        ),
        title: const Text('User Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.backgroundDark, width: 4),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuA6s76PgR7tY-tjq0toDGzFf08u9Xm8e9N74_yeupvSF6LFCIeoPm_stp47pA_Jdu_quZydU3Yh8Yh1pwV-PvLz6RUbfBmwZzf1qb-0qQ4XxHCEjmy62B3APj8OmjOMs5Dhzc252O2sGnpjmoSTDQr5--ND3Kn8JJ4253rS8OGQk0HLg6YsHYUziMRCl2NQLFhavJ4oLGz4FuGnObM158OWTdJUQHVXh22_ehBUiBiX3CqUWly4xnqj4Qr_C1jfvTRHUiYVNKD7C765'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.accentPurple.withOpacity(0.5), blurRadius: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('ID: ${user.id.substring(0, 8)}', style: const TextStyle(color: AppColors.textLight)),

            const SizedBox(height: 24),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard('12', 'Watching', AppColors.primary),
                  const SizedBox(width: 12),
                  _buildStatCard('45', 'Completed', Colors.white),
                  const SizedBox(width: 12),
                  _buildStatCard('128', 'Plan to Watch', Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Activity & Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.history, 'Viewing History', AppColors.primary),
                  const Divider(height: 1, color: Colors.white10),
                  _buildMenuItem(Icons.settings, 'App Settings', AppColors.accentPurple),
                  const Divider(height: 1, color: Colors.white10),
                  _buildMenuItem(Icons.download_for_offline, 'My Downloads', AppColors.primary),
                  const Divider(height: 1, color: Colors.white10),
                  InkWell(
                    onTap: () {
                      authProvider.logout();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.logout, color: Colors.red),
                          ),
                          const SizedBox(width: 16),
                          const Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

             const SizedBox(height: 40),
             const Text('MyDonghua Mobile v1.0.0', style: TextStyle(color: Colors.white24, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }
}
