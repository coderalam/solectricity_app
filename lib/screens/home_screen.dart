import 'package:flutter/material.dart';
import 'load_selection_screen.dart';
import 'capacity_calculator_screen.dart';
import 'land_calculator_screen.dart';
import 'cost_calculator_screen.dart';
import 'financial_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text(
                'সূর্য বিদ্যুৎ (Solectricity)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
            ),
      drawer: isDesktop ? null : _buildDrawer(context),
      body: isDesktop
          ? Row(
              children: [
                _buildPermanentSidebar(context),
                const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28.0),
                    child: _buildMainContent(context),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildMainContent(context),
            ),
    );
  }

  /// সাইডবার
  Widget _buildPermanentSidebar(BuildContext context) {
    return Container(
      width: 270,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.solar_power_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'সূর্য বিদ্যুৎ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Solectricity - BCSIR',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildSidebarSectionTitle('প্রধান গণনা'),
                _HoverMenuTile(
                  icon: Icons.dashboard_rounded,
                  title: 'ড্যাশবোর্ড (হোম)',
                  isActive: true,
                  onTap: () {},
                ),
                _HoverMenuTile(
                  icon: Icons.electrical_services_rounded,
                  title: 'উপকরণভিত্তিক হিসাব',
                  isHighlighted: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadSelectionScreen()));
                  },
                ),
                _HoverMenuTile(
                  icon: Icons.bolt_rounded,
                  title: 'ক্ষমতাভিত্তিক হিসাব',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CapacityCalculatorScreen()));
                  },
                ),
                _HoverMenuTile(
                  icon: Icons.roofing_rounded,
                  title: 'স্থানভিত্তিক হিসাব',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LandCalculatorScreen()));
                  },
                ),
                _HoverMenuTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'খরচভিত্তিক হিসাব',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CostCalculatorScreen()));
                  },
                ),
                _HoverMenuTile(
                  icon: Icons.trending_up_rounded,
                  title: 'আর্থিক লাভ-ক্ষতি (ROI)',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FinancialCalculatorScreen()));
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: Color(0xFFE2E8F0)),
                ),
                _buildSidebarSectionTitle('সহায়ক টুলস'),
                _HoverMenuTile(
                  icon: Icons.compass_calibration_rounded,
                  title: 'সোলার কম্পাস (দক্ষিণমুখী)',
                  onTap: () => _showNotice(context, 'সোলার কম্পাস'),
                ),
                _HoverMenuTile(
                  icon: Icons.architecture_rounded,
                  title: 'লেভেলার (২৫° কোণ মাপক)',
                  onTap: () => _showNotice(context, 'লেভেলার টুল'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: Color(0xFFE2E8F0)),
                ),
                _buildSidebarSectionTitle('তথ্য ও নির্দেশিকা'),
                _HoverMenuTile(
                  icon: Icons.settings_suggest_rounded,
                  title: 'সোলার স্থাপন নির্দেশিকা',
                  onTap: () => _showNotice(context, 'স্থাপন নির্দেশিকা'),
                ),
                _HoverMenuTile(
                  icon: Icons.build_circle_outlined,
                  title: 'ব্যাটারি রক্ষণাবেক্ষণ',
                  onTap: () => _showNotice(context, 'রক্ষণাবেক্ষণ গাইড'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: const [
                Icon(Icons.verified_rounded, color: Colors.blue, size: 16),
                SizedBox(width: 8),
                Text('BCSIR & SREDA Standards', style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
      ),
    );
  }

  /// মূল কন্টেন্ট
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroBanner(),
        const SizedBox(height: 24),

        const Text(
          'সৌর সিস্টেম ক্যালকুলেটর ও নকশা',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 12),

        // ১. প্রধান উপকরণভিত্তিক কার্ড
        _buildPrimaryCard(
          context: context,
          title: 'উপকরণভিত্তিক হিসাব (Based on Load)',
          subTitle: 'আপনার বাসার ফ্যান, লাইট, টিভি, ফ্রিজ ইত্যাদির তালিকা দিয়ে পূর্ণাঙ্গ সোলার প্যানেল, ব্যাটারি, চার্জ কন্ট্রোলার ও ইনভার্টারের হিসাব এবং সংযোগ নকশা তৈরি করুন।',
          icon: Icons.electrical_services_rounded,
          tag: 'সবচেয়ে জনপ্রিয়',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadSelectionScreen()));
          },
        ),

        const SizedBox(height: 20),

        // ২. স্রেডার গঠনমূলক বিবরণীসহ ৪টি কার্ড
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth > 700 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: constraints.maxWidth > 700 ? 1.7 : 1.5,
              children: [
                _buildDetailedCard(
                  title: 'ক্ষমতাভিত্তিক হিসাব (Capacity)',
                  subtitle: 'টার্গেট ওয়াট বা কিলোওয়াট (kW) অনুযায়ী প্যানেল ও ইনভার্টার সাইজিং।',
                  sredaNote: 'স্রেডা মানদণ্ড: ১ কিলোওয়াটে দৈনিক গড়ে ৪.৪ ইউনিট বিদ্যুৎ উৎপাদন হয়।',
                  icon: Icons.bolt_rounded,
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CapacityCalculatorScreen())),
                ),
                _buildDetailedCard(
                  title: 'স্থানভিত্তিক হিসাব (Roof Area)',
                  subtitle: 'ছাদের ফাঁকা ক্ষেত্রফল দিয়ে সর্বোচ্চ কত কিলোওয়াটের সোলার বসানো সম্ভব।',
                  sredaNote: 'স্রেডা মানদণ্ড: ছায়ামুক্ত ছাদে প্রতি কিলোওয়াটে ৮৫ বর্গফুট জায়গা প্রয়োজন।',
                  icon: Icons.roofing_rounded,
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LandCalculatorScreen())),
                ),
                _buildDetailedCard(
                  title: 'খরচভিত্তিক হিসাব (Budget)',
                  subtitle: 'নির্দিষ্ট বাজেটে অন-গ্রিড বা অফ-গ্রিড সেরা সোলার সিস্টেমের রূপরেখা।',
                  sredaNote: 'স্রেডা রেট: অন-গ্রিড ~৬০ হাজার/kW এবং অফ-গ্রিড ব্যাটারিসহ ~৯৫ হাজার/kW।',
                  icon: Icons.account_balance_wallet_rounded,
                  color: Colors.deepPurple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CostCalculatorScreen())),
                ),
                _buildDetailedCard(
                  title: 'আর্থিক বিশ্লেষণ (ROI)',
                  subtitle: 'কত দিনে পুরো মূলধন উঠে আসবে এবং ২৫ বছরে নিট কত টাকা মুনাফা হবে।',
                  sredaNote: 'স্রেডা পলিসি: সরকারি নেট-মিটারিং সুবিধা গ্রহণ করলে ৪-৫ বছরে মূলধন উঠে আসে।',
                  icon: Icons.trending_up_rounded,
                  color: Colors.indigo,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FinancialCalculatorScreen())),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // ৩. স্রেডার গঠনমূলক নীতিমালা কার্ড
        _buildSredaPolicyCard(),
      ],
    );
  }

  /// স্রেডার গঠনমূলক নীতিমালা কার্ড
  Widget _buildSredaPolicyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 24),
              SizedBox(width: 10),
              Text(
                'স্রেডা (SREDA) ও বিসিএসআইআর জাতীয় কারিগরি নির্দেশনা:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E40AF)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '• প্যানেল মুখীকরণ: বাংলাদেশে সর্বোচ্চ বিদ্যুৎ পেতে প্যানেলগুলো ঠিক দক্ষিণমুখী এবং ভূমির সাথে ২৫° কোণে (Tilt Angle) স্থাপন করা বাধ্যতামূলক।\n'
            '• পিক সান-আওয়ার: বাংলাদেশের বার্ষিক সৌর বিকিরণ বিবেচনায় দৈনিক গড় পিক সান-আওয়ার ৫.৫ ঘণ্টা নির্ধারিত।\n'
            '• নেট-মিটারিং সুবিধা: ৩-ফেজ বিদ্যুৎ সংযোগ থাকলে অতিরিক্ত উৎপাদিত বিদ্যুৎ জাতীয় গ্রিডে বিক্রি করে মাসিক বিদ্যুৎ বিল শূন্য করা সম্ভব।',
            style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.6),
          ),
        ],
      ),
    );
  }

  /// হিরো ব্যানার
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.orange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
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
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'বাংলাদেশ বিজ্ঞান ও শিল্প গবেষণা পরিষদ (BCSIR) এবং স্রেডা (SREDA)-এর বৈজ্ঞানিক ফর্মুলা অনুযায়ী প্রস্তুতকৃত।',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.wb_sunny_rounded, size: 64, color: Colors.white),
        ],
      ),
    );
  }

  /// প্রধান কার্ড
  Widget _buildPrimaryCard({
    required BuildContext context,
    required String title,
    required String subTitle,
    required IconData icon,
    required String tag,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.amber.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.amber.shade800, size: 30),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            Text(subTitle, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5)),
            const SizedBox(height: 18),
            Row(
              children: [
                Text('গণনা শুরু করুন', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.amber.shade800),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// স্রেডার তথ্যসংবলিত উন্নত বিস্তারিত কার্ড
  Widget _buildDetailedCard({
    required String title,
    required String subtitle,
    required String sredaNote,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(icon, size: 22, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sredaNote,
                style: TextStyle(fontSize: 11, color: color.withOpacity(0.9), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade800]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.solar_power_rounded, size: 44, color: Colors.white),
                SizedBox(height: 8),
                Text('সূর্য বিদ্যুৎ (Solectricity)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Plug to the sun', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.electrical_services_rounded, color: Colors.amber),
            title: const Text('উপকরণভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadSelectionScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bolt_rounded, color: Colors.blue),
            title: const Text('ক্ষমতাভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CapacityCalculatorScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.roofing_rounded, color: Colors.teal),
            title: const Text('স্থানভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LandCalculatorScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded, color: Colors.deepPurple),
            title: const Text('খরচভিত্তিক হিসাব'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CostCalculatorScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up_rounded, color: Colors.indigo),
            title: const Text('আর্থিক বিশ্লেষণ (ROI)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FinancialCalculatorScreen()));
            },
          ),
        ],
      ),
    );
  }

  void _showNotice(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title খুব শীঘ্রই আসছে!'), duration: const Duration(seconds: 1)),
    );
  }
}

/// সাইডবার হোভার টাইল
class _HoverMenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _HoverMenuTile({
    required this.icon,
    required this.title,
    this.isActive = false,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  State<_HoverMenuTile> createState() => _HoverMenuTileState();
}

class _HoverMenuTileState extends State<_HoverMenuTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color contentColor = const Color(0xFF334155);

    if (widget.isActive) {
      bgColor = Colors.amber.shade700;
      contentColor = Colors.white;
    } else if (_isHovered) {
      bgColor = Colors.amber.shade50;
      contentColor = Colors.amber.shade900;
    } else if (widget.isHighlighted) {
      bgColor = Colors.amber.shade50.withOpacity(0.5);
      contentColor = Colors.amber.shade800;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive ? null : (_isHovered ? Border.all(color: Colors.amber.shade200) : null),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: contentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: contentColor,
                    fontWeight: (widget.isActive || _isHovered || widget.isHighlighted) ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              if (_isHovered && !widget.isActive)
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }
}