import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'সূর্য বিদ্যুৎ (Solectricity)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      // সাইডবার ড্রয়ার মেনু
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ১. টপ হিরো ব্যানার
            _buildHeroBanner(),

            const SizedBox(height: 24),

            // ২. সেকশন টাইটেল
            const Text(
              'সৌর সিস্টেম ক্যালকুলেটর',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // ৩. প্রধান ফিচার কার্ড (উপকরণভিত্তিক হিসাব)
            _buildPrimaryCard(
              context: context,
              title: 'উপকরণভিত্তিক হিসাব',
              subTitle: 'বাসার ফ্যান, লাইট, টিভি ইত্যাদি উপকরণের তালিকা দিয়ে নির্ভুল সোলার, ব্যাটারি ও ইনভার্টারের হিসাব।',
              icon: Icons.electrical_services_rounded,
              tag: 'সবচেয়ে জনপ্রিয়',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('পরবর্তী ধাপে আমরা এই স্ক্রিনটি তৈরি করছি!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ৪. অন্যান্য ক্যালকুলেশন কার্ড গ্রিড
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _buildSecondaryCard(
                  title: 'ক্ষমতাভিত্তিক',
                  subtitle: 'ওয়াট বা কিলোওয়াট অনুযায়ী',
                  icon: Icons.bolt_rounded,
                  color: Colors.blue,
                ),
                _buildSecondaryCard(
                  title: 'স্থানভিত্তিক',
                  subtitle: 'ছাদের ক্ষেত্রফল অনুযায়ী',
                  icon: Icons.roofing_rounded,
                  color: Colors.teal,
                ),
                _buildSecondaryCard(
                  title: 'খরচভিত্তিক',
                  subtitle: 'বাজেট ও সম্ভাব্য খরচ অনুযায়ী',
                  icon: Icons.account_balance_wallet_rounded,
                  color: Colors.deepPurple,
                ),
                _buildSecondaryCard(
                  title: 'আর্থিক বিশ্লেষণ',
                  subtitle: 'কত দিনে টাকা উঠবে (ROI)',
                  icon: Icons.trending_up_rounded,
                  color: Colors.indigo,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ৫. বিসিএসআইআর ইনফো কার্ড
            _buildBcsirBadge(),
          ],
        ),
      ),
    );
  }

  /// হিরো ব্যানার
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.orange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'সৌর-বিদ্যুৎ সিস্টেমের সঠিক ও সাশ্রয়ী বৈজ্ঞানিক হিসাব',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.wb_sunny_rounded,
            size: 54,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  /// প্রধান ফিচার কার্ড
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.08),
              blurRadius: 12,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.amber.shade800, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subTitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  'গণনা শুরু করুন',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.amber.shade800),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// ছোট গ্রিড কার্ড
  Widget _buildSecondaryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, size: 20, color: color),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// বিসিএসআইআর ইনফো ব্যাজ
  Widget _buildBcsirBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'বিসিএসআইআর (BCSIR) বৈজ্ঞানিক ফর্মুলা অনুসরণ করে প্রস্তুতকৃত।',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
            ),
          ),
        ],
      ),
    );
  }

  /// সাইডবার ড্রয়ার
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade700, Colors.orange.shade800],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.solar_power_rounded, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'সূর্য বিদ্যুৎ (Solectricity)',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Plug to the sun',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('হোম'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('পরিচিতি (About)'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('সোলার স্থাপন নির্দেশিকা'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined),
            title: const Text('রক্ষণাবেক্ষণ গাইড'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.compass_calibration_outlined),
            title: const Text('কম্পাস ও লেভেলার টুল'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}