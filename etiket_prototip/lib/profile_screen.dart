import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF379D6E), // Primary green
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF3D200), // Bright yellow
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Title
                    Expanded(
                      child: Text(
                        'Profil',
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Edit Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D200), // Bright yellow
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Düzenle',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Alerjenler
                  _buildMenuItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Alerjenler',
                    onTap: () {
                      // Navigate to allergens page
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Diyetim
                  _buildMenuItem(
                    icon: Icons.restaurant_menu,
                    title: 'Diyetim',
                    onTap: () {
                      // Navigate to diet page
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dini hassasiyetler
                  _buildMenuItem(
                    icon: Icons.mosque,
                    title: 'Dini hassasiyetler',
                    onTap: () {
                      // Navigate to religious preferences page
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Sporcu modu
                  _buildMenuItem(
                    icon: Icons.fitness_center,
                    title: 'Sporcu modu',
                    onTap: () {
                      // Navigate to athlete mode page
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Action Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF379D6E), // Primary green
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D200), // Bright yellow
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ana sayfaya dön',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE6), // Light yellow/cream
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE6E6E6), // Light border
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF379D6E), // Primary green
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF379D6E), // Primary green
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF379D6E), // Primary green
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
