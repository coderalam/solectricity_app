import 'package:flutter/material.dart';

class LandCalculatorScreen extends StatefulWidget {
  const LandCalculatorScreen({super.key});

  @override
  State<LandCalculatorScreen> createState() => _LandCalculatorScreenState();
}

class _LandCalculatorScreenState extends State<LandCalculatorScreen> {
  final double _peakSunHours = 5.5;
  final double _systemEfficiency = 0.80;
  final double _electricityRate = 8.50;
  final double _sqftPerKw = 85.0; // স্রেডা অনুসারে প্রতি কিলোওয়াটে ৮৫ বর্গফুট
  final double _panelWattage = 550.0;

  double _roofAreaSqft = 500.0; // ডিফল্ট ৫০০ বর্গফুট

  @override
  Widget build(BuildContext context) {
    final possibleKw = _roofAreaSqft / _sqftPerKw;
    final panelsCount = ((possibleKw * 1000) / _panelWattage).floor();
    final dailyKwh = possibleKw * _peakSunHours * _systemEfficiency;
    final annualKwh = dailyKwh * 365;
    final annualSavings = annualKwh * _electricityRate;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('স্থানভিত্তিক হিসাব (Land / Roof Area)'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              title: 'ছাদ বা জমির আয়তনভিত্তিক সোলার প্ল্যান',
              subtitle: 'ছাদের ফাঁকা ছায়ামুক্ত জায়গার ওপর নির্ভর করে কতটুকু সোলার সিস্টেম বসানো সম্ভব।',
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ছাদ বা জমির মাপ: ${_roofAreaSqft.toInt()} বর্গফুট (sq. ft.)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Slider(
                      value: _roofAreaSqft,
                      min: 100,
                      max: 5000,
                      divisions: 49,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) => setState(() => _roofAreaSqft = val),
                    ),
                    Text(
                      'আনুমানিক: ${(_roofAreaSqft / 435.6).toStringAsFixed(2)} শতাংশ জায়গা',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard([
              _buildRow('সর্বোচ্চ সোলার স্থাপন ক্ষমতা:', '${possibleKw.toStringAsFixed(2)} kWp'),
              _buildRow('মোট প্যানেল বসানো যাবে:', '$panelsCount টি (${_panelWattage.toInt()}W প্যানেল)'),
              _buildRow('দৈনিক বিদ্যুৎ তৈরি হবে:', '${dailyKwh.toStringAsFixed(1)} ইউনিট (kWh)'),
              _buildRow('বছরে মোট বিদ্যুৎ উৎপাদন:', '${annualKwh.toStringAsFixed(0)} ইউনিট'),
              const Divider(color: Colors.blueGrey),
              _buildRow('বার্ষিক আনুমানিক সাশ্রয়:', '৳ ${annualSavings.toStringAsFixed(0)} টাকা', isBold: true),
            ]),
            const SizedBox(height: 12),
            _buildSredaBadge('স্রেডা (SREDA) গাইডলাইন: সোলার প্যানেলের সাথে ওয়াকওয়ে ও ছায়ার জন্য প্রতি কিলোওয়াটে ৮৫ বর্গফুট আবশ্যক।'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildResultCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFC5E2F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(children: rows),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: FontWeight.bold,
              color: isBold ? const Color(0xFF1E3A8A) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSredaBadge(String note) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, size: 16, color: Colors.amber.shade900),
          const SizedBox(width: 8),
          Expanded(child: Text(note, style: TextStyle(fontSize: 11, color: Colors.amber.shade900))),
        ],
      ),
    );
  }
}