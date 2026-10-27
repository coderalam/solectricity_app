import 'package:flutter/material.dart';

class FinancialCalculatorScreen extends StatefulWidget {
  const FinancialCalculatorScreen({super.key});

  @override
  State<FinancialCalculatorScreen> createState() => _FinancialCalculatorScreenState();
}

class _FinancialCalculatorScreenState extends State<FinancialCalculatorScreen> {
  final double _peakSunHours = 5.5;
  final double _systemEfficiency = 0.80;
  final double _electricityRate = 8.50;

  double _monthlyBill = 3500.0; // ডিফল্ট ৩৫০০ টাকা বিদ্যুৎ বিল

  @override
  Widget build(BuildContext context) {
    final monthlyUnitsConsumed = _monthlyBill / _electricityRate;
    final requiredKw = monthlyUnitsConsumed / (30 * _peakSunHours * _systemEfficiency);
    final estimatedSystemCost = requiredKw * 65000.0; // অন-গ্রিড গড় খরচ
    final annualSavings = _monthlyBill * 12;
    final paybackYears = estimatedSystemCost / (annualSavings > 0 ? annualSavings : 1);
    final lifetimeSavings25Years = (annualSavings * 25) - estimatedSystemCost;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('আর্থিক বিশ্লেষণ ও লাভ-ক্ষতি (Financial ROI)'),
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
              title: 'রিটার্ন অব ইনভেস্টমেন্ট (ROI) বিশ্লেষণ',
              subtitle: 'সোলার লাগালে আপনার বিদ্যুৎ বিল কত বাঁচবে, কত বছরে পুরো মূলধন উঠে আসবে এবং ২৫ বছরে নিট মুনাফা কত।',
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
                      'বর্তমান মাসিক গড় বিদ্যুৎ বিল: ৳ ${_monthlyBill.toInt()} টাকা',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Slider(
                      value: _monthlyBill,
                      min: 1000,
                      max: 30000,
                      divisions: 29,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) => setState(() => _monthlyBill = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard([
              _buildRow('মাসিক ব্যবহৃত বিদ্যুৎ:', '${monthlyUnitsConsumed.toStringAsFixed(0)} ইউনিট'),
              _buildRow('প্রয়োজনীয় সোলার প্ল্যান্ট:', '${requiredKw.toStringAsFixed(2)} kW (${(requiredKw * 1000).toInt()}W)'),
              _buildRow('আনুমানিক প্রাথমিক খরচ:', '৳ ${estimatedSystemCost.toStringAsFixed(0)} টাকা'),
              _buildRow('বার্ষিক সরাসরি বিল সাশ্রয়:', '৳ ${annualSavings.toStringAsFixed(0)} টাকা'),
              const Divider(color: Colors.blueGrey),
              _buildRow('মূলধন ফেরত আসার সময় (Payback):', '${paybackYears.toStringAsFixed(1)} বছর', isBold: true),
              _buildRow('২৫ বছরে নিট মুনাফা/সাশ্রয়:', '৳ ${(lifetimeSavings25Years / 100000).toStringAsFixed(2)} লক্ষ টাকা', isBold: true),
            ]),
            const SizedBox(height: 12),
            _buildSredaBadge('প্যানেল লাইফটাইম ২৫ বছর হিসেবে এই আর্থিক মডেল প্রস্তুত। স্রেডা নেট-মিটারিং নীতিমালা অনুসারে লাভজনক।'),
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