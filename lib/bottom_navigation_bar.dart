import 'package:flutter/material.dart';
import 'home_page.dart';
import 'community.dart';
import 'disease_detect.dart';
import 'account.dart';
import 'shop.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFA7C7A1).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 80, // Standard height for bottom navigation
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Stack(
            children: [
              // Main Navigation Bar
              Padding(
                padding: EdgeInsets.only(top: 0), // No extra padding needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Home
                    _buildNavItem(
                      context: context,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                      isActive: currentIndex == 0,
                      onTap: () {
                        onTap(0);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                    // Consult
                    _buildNavItem(
                      context: context,
                      icon: Icons.healing_outlined,
                      activeIcon: Icons.healing,
                      label: 'Consult',
                      isActive: currentIndex == 1,
                      onTap: () {
                        onTap(1);
                        Navigator.pushReplacement(
                          context,
                   MaterialPageRoute(builder: (context) => ShopPage()),
                        );
                      },
                    ),
                    // Analyze
                    _buildNavItem(
                      context: context,
                      icon: Icons.psychology_outlined,
                      activeIcon: Icons.psychology,
                      label: 'Analyze',
                      isActive: currentIndex == 2,
                      onTap: () {
                        onTap(2);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CropDiseaseHome()),
                        );
                      },
                    ),
                    // Community
                    _buildNavItem(
                      context: context,
                      icon: Icons.people_outline,
                      activeIcon: Icons.people,
                      label: 'Community',
                      isActive: currentIndex == 3,
                      onTap: () {
                        onTap(3);
                        Navigator.pushReplacement(
                          context,
                            MaterialPageRoute(builder: (context) => CommunityPage()),
          
                        );
                      },
                    ),
                    // Profile
                    _buildNavItem(
                      context: context,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                      isActive: currentIndex == 4,
                      onTap: () {
                        onTap(4);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AccountPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF27C2A4).withOpacity(0.1),
                    const Color(0xFFA7C7A1).withOpacity(0.1),
                  ],
                )
              : null,
          border: isActive 
              ? Border.all(
                  color: const Color(0xFF27C2A4).withOpacity(0.2),
                  width: 1,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? const Color(0xFF27C2A4) : const Color(0xFF2F2F2F).withOpacity(0.6),
                size: 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF27C2A4) : const Color(0xFF2F2F2F).withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }


}