import 'package:flutter/material.dart';

class CostCalculatorScreen extends StatefulWidget {
  const CostCalculatorScreen({super.key});

  @override
  State<CostCalculatorScreen> createState() => _CostCalculatorScreenState();
}

class _CostCalculatorScreenState extends State<CostCalculatorScreen> {
  final double _peakSunHours = 5.5;
  final double _systemEfficiency = 0.80;
  final double _electricityRate = 8.50;
  final double _sqftPerKw = 85.0;
  final double _panelWattage = 550.0;

  double _budgetAmount = 200000.0; // ডিফল্ট ২ লাখ টাকা
  bool _isOffGrid = true;          // অফ-গ্রিড ব্যাটারিসহ

  @override
  Widget build(BuildContext context) {
    // বাংলাদেশ মার্কেট রেট: অফ-গ্রিড ~৯৫,০০০ টাকা/kW, অন-গ্রিড ~৬০,০০০ টাকা/kW
    final costPerKw = _isOffGrid ? 95000.0 : 60000.0;
    final affordableKw = _budgetAmount / costPerKw;
    final panelsCount = ((affordableKw * 1000) / _panelWattage).floor();
    final dailyKwh = affordableKw * _peakSunHours * _systemEfficiency;
    final monthlySavings = dailyKwh * 30 * _electricityRate;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('খরচভিত্তিক হিসাব (Cost / Budget Based)'),
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
              title: 'নির্দিষ্ট বাজেটে সর্বোচ্চ সোলার প্ল্যান',
              subtitle: 'আপনার বাজেটের মধ্যে অন-গ্রিড বা অফ-গ্রিড কতটুকু সোলার সিস্টেম তৈরি করা সম্ভব।',
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
                      'আপনার বাজেট: ৳ ${(_budgetAmount / 1000).toStringAsFixed(0)} হাজার (${_budgetAmount.toInt()} টাকা)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Slider(
                      value: _budgetAmount,
                      min: 50000,
                      max: 1500000,
                      divisions: 29,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) => setState(() => _budgetAmount = val),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('সিস্টেমের ধরন:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ChoiceChip(
                          label: const Text('অফ-গ্রিড (ব্যাটারিসহ)'),
                          selected: _isOffGrid,
                          selectedColor: Colors.amber.shade100,
                          onSelected: (val) => setState(() => _isOffGrid = true),
                        ),
                        ChoiceChip(
                          label: const Text('অন-গ্রিড (ব্যাটারি ছাড়া)'),
                          selected: !_isOffGrid,
                          selectedColor: Colors.blue.shade100,
                          onSelected: (val) => setState(() => _isOffGrid = false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard([
              _buildRow('এই বাজেটে সক্ষমতা:', '${affordableKw.toStringAsFixed(2)} kW (${(affordableKw * 1000).toInt()}W)'),
              _buildRow('প্যানেলের সংখ্যা:', '$panelsCount টি (${_panelWattage.toInt()}W)'),
              _buildRow('দৈনিক বিদ্যুৎ উৎপাদন:', '${dailyKwh.toStringAsFixed(1)} ইউনিট'),
              _buildRow('প্রয়োজনীয় ছাদ:', '${(affordableKw * _sqftPerKw).toInt()} বর্গফুট'),
              const Divider(color: Colors.blueGrey),
              _buildRow('মাসিক আনুমানিক সাশ্রয়:', '৳ ${monthlySavings.toStringAsFixed(0)} টাকা', isBold: true),
            ]),
            const SizedBox(height: 12),
            _buildSredaBadge('বাজারদর ভিত্তি: অফ-গ্রিড ব্যাটারিসহ ~৯৫ হাজার/kW এবং অন-গ্রিড নেট-মিটারিং ~৬০ হাজার/kW (বাংলাদেশ মার্কেট রেট)'),
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