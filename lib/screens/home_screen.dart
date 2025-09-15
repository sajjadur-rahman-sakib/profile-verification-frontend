import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify/screens/signup_screen.dart';
import 'package:verify/widgets/button_card.dart';
import 'package:verify/screens/login_screen.dart';
import 'package:verify/screens/profile_screen.dart';
import 'package:verify/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> demoImages = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image1.png',
    'assets/images/image2.png',
  ];

  int _currentIndex = 0;
  int _selectedIndex = 0;
  bool _isAutoPlay = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'VERIFY',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color.fromARGB(255, 154, 196, 208),
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Used to verify user profile.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: demoImages.length,
                          itemBuilder: (context, index, realIdx) {
                            final path = demoImages[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTapDown: (_) {
                                    setState(() {
                                      _isAutoPlay = false;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isAutoPlay = true;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isAutoPlay = true;
                                    });
                                  },
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.black26,
                                                ),
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: false,
                            autoPlay: _isAutoPlay,
                            autoPlayInterval: const Duration(seconds: 2),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.easeInOut,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: demoImages.asMap().entries.map((entry) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == entry.key
                                    ? const Color.fromARGB(255, 154, 196, 208)
                                    : Colors.black26,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    ButtonCard(
                      icon: Icons.do_not_disturb,
                      label: 'Not Implement',
                      onTap: () {},
                    ),
                    ButtonCard(
                      icon: Icons.search,
                      label: 'Search',
                      onTap: () {},
                    ),
                    ButtonCard(
                      icon: Icons.do_not_disturb,
                      label: 'Not Implement',
                      onTap: () {},
                    ),
                    ButtonCard(
                      icon: Icons.login,
                      label: 'Login',
                      onTap: () {
                        final authBloc = context.read<AuthBloc>();
                        if (authBloc.currentUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    ButtonCard(
                      icon: Icons.person,
                      label: 'Profile',
                      onTap: () {
                        final authBloc = context.read<AuthBloc>();
                        if (authBloc.currentUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    ButtonCard(
                      icon: Icons.add_box_outlined,
                      label: 'Signup',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 154, 196, 208),
        unselectedItemColor: Colors.black45,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.grid_view),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.star_border),
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(onTap: () {}, child: const Icon(Icons.inbox)),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(onTap: () {}, child: const Icon(Icons.menu)),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
