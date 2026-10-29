import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'load_selection_screen.dart';
import 'capacity_calculator_screen.dart';
import 'land_calculator_screen.dart';
import 'cost_calculator_screen.dart';
import 'financial_calculator_screen.dart';
import 'solar_tools_screen.dart';
import 'contact_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  void _onMenuTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: isDesktop
          ? null
          : AppBar(
              title: InkWell(
                onTap: () => _onMenuTapped(0),
                child: const Text(
                  'সূর্য বিদ্যুৎ (Solectricity)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
            ),
      drawer: isDesktop ? null : _buildMobileDrawer(),
      body: isDesktop
          ? Row(
              children: [
                _buildCompactSidebar(),
                const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: _buildSelectedScreen(),
                ),
              ],
            )
          : _buildSelectedScreen(),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const LoadSelectionScreen();
      case 2:
        return const CapacityCalculatorScreen();
      case 3:
        return const LandCalculatorScreen();
      case 4:
        return const CostCalculatorScreen();
      case 5:
        return const FinancialCalculatorScreen();
      case 6:
        return const SolarToolsScreen(key: ValueKey('compass'), initialTabIndex: 0);
      case 7:
        return const SolarToolsScreen(key: ValueKey('leveler'), initialTabIndex: 1);
      case 8:
        return const SolarToolsScreen(key: ValueKey('guide'), initialTabIndex: 2);
      case 9:
        return const ContactScreen(key: ValueKey('contact'), initialTab: 0); // যোগাযোগ
      case 10:
        return const ContactScreen(key: ValueKey('website'), initialTab: 1); // বিসিএসআইআর ওয়েব
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildCompactSidebar() {
    return Container(
      width: 225,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // লোগো ও ব্র্যান্ডিং (গ্লোবাল হোম লিংক)
          InkWell(
            onTap: () => _onMenuTapped(0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.orange.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: SolarFusionSun(size: 24, isMini: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'সূর্য বিদ্যুৎ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'BCSIR & SREDA',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildSectionHeader('প্রধান গণনা'),
                  _CompactMenuTile(
                    icon: Icons.dashboard_rounded,
                    title: 'ড্যাশবোর্ড (হোম)',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _onMenuTapped(0),
                  ),
                  _CompactMenuTile(
                    icon: Icons.electrical_services_rounded,
                    title: 'উপকরণভিত্তিক হিসাব',
                    isSelected: _selectedIndex == 1,
                    onTap: () => _onMenuTapped(1),
                  ),
                  _CompactMenuTile(
                    icon: Icons.bolt_rounded,
                    title: 'ক্ষমতাভিত্তিক হিসাব',
                    isSelected: _selectedIndex == 2,
                    onTap: () => _onMenuTapped(2),
                  ),
                  _CompactMenuTile(
                    icon: Icons.roofing_rounded,
                    title: 'স্থানভিত্তিক হিসাব',
                    isSelected: _selectedIndex == 3,
                    onTap: () => _onMenuTapped(3),
                  ),
                  _CompactMenuTile(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'খরচভিত্তিক হিসাব',
                    isSelected: _selectedIndex == 4,
                    onTap: () => _onMenuTapped(4),
                  ),
                  _CompactMenuTile(
                    icon: Icons.trending_up_rounded,
                    title: 'আর্থিক বিশ্লেষণ (ROI)',
                    isSelected: _selectedIndex == 5,
                    onTap: () => _onMenuTapped(5),
                  ),

                  const Divider(height: 12, thickness: 0.8, color: Color(0xFFE2E8F0)),

                  _buildSectionHeader('সহায়ক টুলস'),
                  _CompactMenuTile(
                    icon: Icons.compass_calibration_rounded,
                    title: 'সোলার কম্পাস (দক্ষিণ)',
                    isSelected: _selectedIndex == 6,
                    onTap: () => _onMenuTapped(6),
                  ),
                  _CompactMenuTile(
                    icon: Icons.architecture_rounded,
                    title: 'লেভেলার (২৫° কোণ)',
                    isSelected: _selectedIndex == 7,
                    onTap: () => _onMenuTapped(7),
                  ),
                  _CompactMenuTile(
                    icon: Icons.menu_book_rounded,
                    title: 'রক্ষণাবেক্ষণ গাইড',
                    isSelected: _selectedIndex == 8,
                    onTap: () => _onMenuTapped(8),
                  ),

                  const Divider(height: 12, thickness: 0.8, color: Color(0xFFE2E8F0)),

                  _buildSectionHeader('যোগাযোগ ও তথ্য'),
                  _CompactMenuTile(
                    icon: Icons.email_outlined,
                    title: 'যোগাযোগ',
                    isSelected: _selectedIndex == 9,
                    onTap: () => _onMenuTapped(9),
                  ),
                  _CompactMenuTile(
                    icon: Icons.language_rounded,
                    title: 'বিসিএসআইআর ওয়েব',
                    isSelected: _selectedIndex == 10,
                    onTap: () => _onMenuTapped(10),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: const [
                Icon(Icons.verified_rounded, color: Colors.blue, size: 14),
                SizedBox(width: 6),
                Text(
                  'স্রেডা ও বিসিএসআইআর মানদণ্ড',
                  style: TextStyle(fontSize: 10, color: Color(0xFF475569), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(),
          const SizedBox(height: 20),

          const Text(
            'সৌর সিস্টেম ক্যালকুলেটর ও নকশা',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),

          _buildPrimaryFeatureCard(),

          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 700 ? 2 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: count,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: constraints.maxWidth > 700 ? 2.1 : 1.6,
                children: [
                  _buildDetailedGridCard(
                    title: 'ক্ষমতাভিত্তিক হিসাব (Capacity)',
                    subtitle: 'টার্গেট ওয়াট বা কিলোওয়াট (kW) অনুযায়ী প্যানেল ও ইনভার্টার সাইজিং।',
                    sredaNote: 'স্রেডা মানদণ্ড: ১ কিলোওয়াটে দৈনিক গড়ে ৪.৪ ইউনিট বিদ্যুৎ উৎপাদন হয়।',
                    icon: Icons.bolt_rounded,
                    color: Colors.blue,
                    onTap: () => _onMenuTapped(2),
                  ),
                  _buildDetailedGridCard(
                    title: 'স্থানভিত্তিক হিসাব (Roof Area)',
                    subtitle: 'ছাদের ফাঁকা ক্ষেত্রফল দিয়ে সর্বোচ্চ কত কিলোওয়াটের সোলার বসানো সম্ভব।',
                    sredaNote: 'স্রেডা মানদণ্ড: ছায়ামুক্ত ছাদে প্রতি কিলোওয়াটে ৮৫ বর্গফুট জায়গা প্রয়োজন।',
                    icon: Icons.roofing_rounded,
                    color: Colors.teal,
                    onTap: () => _onMenuTapped(3),
                  ),
                  _buildDetailedGridCard(
                    title: 'খরচভিত্তিক হিসাব (Budget)',
                    subtitle: 'নির্দিষ্ট বাজেটে অন-গ্রিড বা অফ-গ্রিড সেরা সোলার সিস্টেমের রূপরেখা।',
                    sredaNote: 'স্রেডা রেট: অন-গ্রিড ~৬০ হাজার/kW এবং অফ-গ্রিড ব্যাটারিসহ ~৯৫ হাজার/kW।',
                    icon: Icons.account_balance_wallet_rounded,
                    color: Colors.deepPurple,
                    onTap: () => _onMenuTapped(4),
                  ),
                  _buildDetailedGridCard(
                    title: 'আর্থিক বিশ্লেষণ (ROI)',
                    subtitle: 'কত দিনে পুরো মূলধন উঠে আসবে এবং ২৫ বছরে নিট কত টাকা মুনাফা হবে।',
                    sredaNote: 'স্রেডা পলিসি: সরকারি নেট-মিটারিং সুবিধা গ্রহণ করলে ৪-৫ বছরে মূলধন উঠে আসে।',
                    icon: Icons.trending_up_rounded,
                    color: Colors.indigo,
                    onTap: () => _onMenuTapped(5),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),
          _buildSredaPolicyCard(),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return InkWell(
      onTap: () => _onMenuTapped(0),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade800, Colors.orange.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.orange.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ঘরের মাঝে রবির কিরণ',
                    style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'বাংলাদেশ বিজ্ঞান ও শিল্প গবেষণা পরিষদ (BCSIR) এবং স্রেডা (SREDA)-এর বৈজ্ঞানিক ফর্মুলা অনুযায়ী প্রস্তুতকৃত।',
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const SolarFusionSun(size: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryFeatureCard() {
    return InkWell(
      onTap: () => _onMenuTapped(1),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.amber.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.electrical_services_rounded, color: Colors.amber.shade800, size: 26),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    'সবচেয়ে জনপ্রিয়',
                    style: TextStyle(color: Colors.green.shade800, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'উপকরণভিত্তিক হিসাব (Based on Load)',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            const Text(
              'আপনার বাসার ফ্যান, লাইট, টিভি, ফ্রিজ ইত্যাদির তালিকা দিয়ে পূর্ণাঙ্গ সোলার প্যানেল, ব্যাটারি, চার্জ কন্ট্রোলার ও ইনভার্টারের হিসাব এবং সংযোগ নকশা তৈরি করুন।',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('গণনা শুরু করুন', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.amber.shade800),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedGridCard({
    required String title,
    required String subtitle,
    required String sredaNote,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sredaNote,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.9), fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSredaPolicyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                'স্রেডা (SREDA) ও বিসিএসআইআর জাতীয় কারিগরি নির্দেশনা:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E40AF)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• প্যানেল মুখীকরণ: বাংলাদেশে সর্বোচ্চ বিদ্যুৎ পেতে প্যানেলগুলো ঠিক দক্ষিণমুখী এবং ভূমির সাথে ২৫° কোণে (Tilt Angle) স্থাপন করা আবশ্যক।\n'
            '• পিক সান-আওয়ার: বাংলাদেশের গড় পিক সান-আওয়ার ৫.৫ ঘণ্টা নির্ধারিত।\n'
            '• নেট-মিটারিং সুবিধা: ৩-ফেজ বিদ্যুৎ সংযোগ থাকলে অতিরিক্ত বিদ্যুৎ জাতীয় গ্রিডে বিক্রি করে মাসিক বিদ্যুৎ বিল শূন্য করা সম্ভব।',
            style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade800]),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _onMenuTapped(0);
              },
              child: Row(
                children: [
                  const SolarFusionSun(size: 44, isMini: true),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('সূর্য বিদ্যুৎ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Plug to the sun', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('ড্যাশবোর্ড'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.electrical_services_rounded, color: Colors.amber),
            title: const Text('উপকরণভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bolt_rounded, color: Colors.blue),
            title: const Text('ক্ষমতাভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.roofing_rounded, color: Colors.teal),
            title: const Text('স্থানভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded, color: Colors.deepPurple),
            title: const Text('খরচভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(4);
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up_rounded, color: Colors.indigo),
            title: const Text('আর্থিক বিশ্লেষণ (ROI)'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(5);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.compass_calibration_rounded),
            title: const Text('সোলার কম্পাস'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(6);
            },
          ),
          ListTile(
            leading: const Icon(Icons.architecture_rounded),
            title: const Text('লেভেলার (২৫° কোণ)'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(7);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded),
            title: const Text('রক্ষণাবেক্ষণ গাইড'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(8);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email_outlined, color: Colors.amber),
            title: const Text('যোগাযোগ'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(9);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: Colors.green),
            title: const Text('বিসিএসআইআর ওয়েব'),
            onTap: () {
              Navigator.pop(context);
              _onMenuTapped(10);
            },
          ),
        ],
      ),
    );
  }
}

/// সাইডবার হোভার মেনু টাইল
class _CompactMenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactMenuTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CompactMenuTile> createState() => _CompactMenuTileState();
}

class _CompactMenuTileState extends State<_CompactMenuTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color contentColor = const Color(0xFF334155);

    if (widget.isSelected) {
      bgColor = Colors.amber.shade700;
      contentColor = Colors.white;
    } else if (_isHovered) {
      bgColor = Colors.amber.shade50;
      contentColor = Colors.amber.shade900;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: widget.isSelected ? null : (_isHovered ? Border.all(color: Colors.amber.shade200) : null),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 17, color: contentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: contentColor,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isSelected)
                const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// ফিউশন সূর্যের অ্যানিমেশন উইজেট
class SolarFusionSun extends StatefulWidget {
  final double size;
  final bool isMini;

  const SolarFusionSun({super.key, this.size = 64, this.isMini = false});

  @override
  State<SolarFusionSun> createState() => _SolarFusionSunState();
}

class _SolarFusionSunState extends State<SolarFusionSun> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = 1.0 + 0.06 * math.sin(_controller.value * 2 * math.pi * 3);

        return Transform.scale(
          scale: widget.isMini ? 1.0 : pulse,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _SolarRaysPainter(isMini: widget.isMini),
                  ),
                ),
                Transform.rotate(
                  angle: -_controller.value * 2 * math.pi * 0.5,
                  child: Container(
                    width: widget.size * 0.65,
                    height: widget.size * 0.65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.amber.shade200.withOpacity(0.8),
                          Colors.orange.shade600.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        stops: const [0.2, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: widget.size * 0.45,
                  height: widget.size * 0.45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFFEF08A),
                        Color(0xFFF59E0B),
                        Color(0xFFEA580C),
                      ],
                      stops: [0.15, 0.45, 0.8, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade300.withOpacity(0.9),
                        blurRadius: widget.size * 0.35,
                        spreadRadius: widget.size * 0.08,
                      ),
                      BoxShadow(
                        color: Colors.orange.shade700.withOpacity(0.6),
                        blurRadius: widget.size * 0.5,
                        spreadRadius: widget.size * 0.15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SolarRaysPainter extends CustomPainter {
  final bool isMini;
  _SolarRaysPainter({this.isMini = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final count = isMini ? 8 : 14;
    final radius = size.width / 2;

    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * math.pi) / count;
      final rayLength = (i % 2 == 0) ? radius : radius * 0.78;

      final start = Offset(
        center.dx + (size.width * 0.26) * math.cos(angle),
        center.dy + (size.width * 0.26) * math.sin(angle),
      );

      final end = Offset(
        center.dx + rayLength * math.cos(angle),
        center.dy + rayLength * math.sin(angle),
      );

      final paint = Paint()
        ..color = (i % 2 == 0) ? const Color(0xFFFEF08A).withOpacity(0.85) : Colors.amber.shade400.withOpacity(0.6)
        ..strokeWidth = isMini ? 1.5 : (i % 2 == 0 ? 3.0 : 2.0)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}