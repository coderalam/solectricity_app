import 'package:flutter/material.dart';

class CapacityCalculatorScreen extends StatefulWidget {
  const CapacityCalculatorScreen({super.key});

  @override
  State<CapacityCalculatorScreen> createState() => _CapacityCalculatorScreenState();
}

class _CapacityCalculatorScreenState extends State<CapacityCalculatorScreen> {
  // স্রেডা ও বিসিএসআইআর স্ট্যান্ডার্ড
  final double _peakSunHours = 5.5;      // বাংলাদেশের গড় রোদ ঘণ্টা
  final double _systemEfficiency = 0.80; // ৮০% সিস্টেম দক্ষতা
  final double _electricityRate = 8.50;  // প্রতি ইউনিট গড় মূল্য
  final double _sqftPerKw = 85.0;        // ১ কিলোওয়াটে ছাদের মাপ
  final double _panelWattage = 550.0;    // আধুনিক মনো-পার্ক প্যানেল

  double _capacityKw = 2.0; // ডিফল্ট ২ কিলোওয়াট (২০০০ ওয়াট)

  // ড্রপডাউনের জনপ্রিয় অপশনগুলো (ওয়াট ও কিলোওয়াট)
  final List<Map<String, dynamic>> _presetCapacities = [
    {'label': '৫০০ ওয়াট (০.৫ kW) - ছোট বাসা / বেসিক লোড', 'value': 0.5},
    {'label': '১০০০ ওয়াট (১.০ kW) - ফ্যান ও লাইট', 'value': 1.0},
    {'label': '১৫০০ ওয়াট (১.৫ kW) - সাধারণ পরিবার', 'value': 1.5},
    {'label': '২০০০ ওয়াট (২.০ kW) - ফ্রিজ ও ফ্যান-লাইট', 'value': 2.0},
    {'label': '৩০০০ ওয়াট (৩.০ kW) - এসি / ফ্রিজসহ বড় বাড়ি', 'value': 3.0},
    {'label': '৫০০০ ওয়াট (৫.০ kW) - কমার্শিয়াল / নেট মিটারিং', 'value': 5.0},
    {'label': '১০০০০ ওয়াট (১০.০ kW) - অফিস / কারখানা', 'value': 10.0},
  ];

  @override
  Widget build(BuildContext context) {
    final double totalWatts = _capacityKw * 1000;
    final dailyKwh = _capacityKw * _peakSunHours * _systemEfficiency;
    final monthlyKwh = dailyKwh * 30;
    final panelsCount = (totalWatts / _panelWattage).ceil();
    final inverterKva = _capacityKw * 1.25;
    final monthlySavings = monthlyKwh * _electricityRate;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('ক্ষমতাভিত্তিক হিসাব (Capacity Based)'),
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
              title: 'সিস্টেম ক্ষমতা অনুযায়ী সাইজিং',
              subtitle: 'আপনার প্রয়োজনীয় মোট ওয়াট বা কিলোওয়াটের ওপর ভিত্তি করে প্যানেল, ইনভার্টার ও বিদ্যুৎ উৎপাদনের হিসাব।',
            ),
            const SizedBox(height: 16),

            // ওয়াট ও কিলোওয়াট ড্রপডাউন কার্ড
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'জনপ্রিয় ওয়াট / কিলোওয়াট নির্বাচন করুন:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    // ১. ড্রপডাউন
                    DropdownButtonFormField<double>(
                      value: _presetCapacities.any((p) => (p['value'] as double) == _capacityKw)
                          ? _capacityKw
                          : null,
                      hint: const Text('তালিকা থেকে ড্রপডাউনে বেছে নিন'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber.shade50.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.amber.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: _presetCapacities.map((preset) {
                        return DropdownMenuItem<double>(
                          value: preset['value'] as double,
                          child: Text(
                            preset['label'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _capacityKw = val);
                      },
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // ২. স্লাইডার দিয়ে সূক্ষ্ম পরিবর্তন
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('নির্দিষ্ট ক্ষমতা:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${totalWatts.toInt()} Watts (${_capacityKw.toStringAsFixed(1)} kW)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amber.shade900),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _capacityKw,
                      min: 0.5,
                      max: 20.0,
                      divisions: 39,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) => setState(() => _capacityKw = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ফলাফলের কার্ড
            _buildResultCard([
              _buildRow('টার্গেট ওয়াট ক্ষমতা:', '${totalWatts.toInt()} W (${_capacityKw.toStringAsFixed(1)} kW)'),
              _buildRow('দৈনিক গড় উৎপাদন:', '${dailyKwh.toStringAsFixed(1)} ইউনিট (kWh)'),
              _buildRow('মাসিক বিদ্যুৎ উৎপাদন:', '${monthlyKwh.toStringAsFixed(0)} ইউনিট (kWh)'),
              _buildRow('সোলার প্যানেলের সংখ্যা:', '$panelsCount টি (${_panelWattage.toInt()}W মনো-পার্ক)'),
              _buildRow('ইনভার্টার সাইজ (ন্যূনতম):', '${inverterKva.toStringAsFixed(2)} kVA'),
              _buildRow('প্রয়োজনীয় ছাদের মাপ:', '${(_capacityKw * _sqftPerKw).toInt()} বর্গফুট'),
              const Divider(color: Colors.blueGrey),
              _buildRow('মাসিক বিল সাশ্রয়:', '৳ ${monthlySavings.toStringAsFixed(0)} টাকা', isBold: true),
            ]),
            const SizedBox(height: 12),
            _buildSredaBadge('স্রেডা ও বিসিএসআইআর স্ট্যান্ডার্ড: দৈনিক উৎপাদন = kW × ৫.৫ PSH × ০.৮০ পারফরম্যান্স রেশিও।'),
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