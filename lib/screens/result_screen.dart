import 'package:flutter/material.dart';
import '../models/appliance_model.dart';
import '../models/solar_result_model.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final SolarCalculationResult result;
  final SolarParameters params;
  final List<ApplianceModel> appliances;

  const ResultScreen({
    super.key,
    required this.result,
    required this.params,
    required this.appliances,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('সিস্টেম ডিজাইন ও ফলাফল'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ১. সফলতার ব্যানার
            _buildSuccessBanner(),

            const SizedBox(height: 16),

            // ২. সোলার সিস্টেমের মূল ফলাফল কার্ড
            _buildResultCard(),

            const SizedBox(height: 16),

            // ৩. সিস্টেম ওয়্যারিং ডায়াগ্রাম (BCSIR-এর ২৪টি ছবির মধ্য থেকে নির্বাচিত ছবি)
            _buildDiagramCard(),

            const SizedBox(height: 20),

            // ৪. হোম পেজে ফিরে যাওয়ার বাটন
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('হোম পেজে ফিরে যান', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4E79),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// টপ সাকসেস ব্যানার
  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade700,
            radius: 18,
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ডিজাইন সফলভাবে সম্পন্ন হয়েছে!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade900),
                ),
                Text(
                  'মোট দৈনিক চাহিদা: ${result.totalEnergyWh.toStringAsFixed(0)} Wh (এসি: ${result.totalAcWh.toStringAsFixed(0)} Wh, ডিসি: ${result.totalDcWh.toStringAsFixed(0)} Wh)',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ফলাফলের কার্ড (BCSIR পুরোনো অ্যাপের হুবহু টেক্সট ফরম্যাট)
  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFC5E2F9), // BCSIR অফিশিয়াল নীল ব্যাকগ্রাউন্ড
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আপনার মোট ${result.totalSolarWattNeeded.toStringAsFixed(0)} Wp-এর সোলার প্যানেল প্রয়োজন',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          _buildResultItem(
            '• মোট সোলার প্যানেল:',
            '${result.totalPanels} টি (${params.panelPmax.toStringAsFixed(0)} Wp সোলার প্যানেল)',
          ),
          _buildResultItem(
            '• সংযোগের নিয়ম:',
            '${result.panelsInSeries} টি সিরিজ  ×  ${result.panelsInParallel} টি প্যারালাল',
          ),
          const Divider(color: Colors.blueGrey),
          _buildResultItem(
            '• মোট ব্যাটারি ক্ষমতা:',
            '${params.systemVoltage.toStringAsFixed(0)}V, ${result.totalBatteryAh.toStringAsFixed(0)} Ah',
          ),
          _buildResultItem(
            '• ব্যাটারির সংখ্যা:',
            '${result.totalBatteries} টি (${params.batteryAh.toStringAsFixed(0)} Ah ব্যাটারি সিরিজে সংযোগ)',
          ),
          const Divider(color: Colors.blueGrey),
          _buildResultItem(
            '• চার্জ কন্ট্রোলার:',
            '${params.systemVoltage.toStringAsFixed(0)} V, ${result.chargeControllerAmps.toStringAsFixed(0)} A',
          ),
          _buildResultItem(
            '• ইনভার্টার (ন্যূনতম):',
            '${params.systemVoltage.toStringAsFixed(0)} V, ${result.inverterVA.toStringAsFixed(0)} VA',
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

  /// ওয়্যারিং ডায়াগ্রাম কার্ড (ছবি)
  Widget _buildDiagramCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_tree_outlined, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'প্রকল্প সংযোগ নকশা (Schematic Design)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/${result.schematicDiagramName}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.solar_power, size: 40, color: Colors.grey.shade500),
                          const SizedBox(height: 6),
                          Text(
                            'নকশা: ${result.schematicDiagramName}',
                            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            '(ছবিটি assets/images ফোল্ডারে থাকলে লোড হবে)',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}