import 'package:flutter/material.dart';
import '../models/appliance_model.dart';
import '../models/solar_result_model.dart';
import '../logic/solar_engine.dart';
import 'result_screen.dart';

class SystemParameterScreen extends StatefulWidget {
  final List<ApplianceModel> appliances;

  const SystemParameterScreen({super.key, required this.appliances});

  @override
  State<SystemParameterScreen> createState() => _SystemParameterScreenState();
}

class _SystemParameterScreenState extends State<SystemParameterScreen> {
  // প্যারামিটার ফিল্ডগুলোর কন্ট্রোলার
  late double _systemVoltage;
  final TextEditingController _pmaxController = TextEditingController(text: '150');
  final TextEditingController _vocController = TextEditingController(text: '21');
  final TextEditingController _iscController = TextEditingController(text: '8.5');
  final TextEditingController _batteryAhController = TextEditingController(text: '100');

  double _batteryDod = 70.0; // ৭০%
  double _batteryEfficiency = 80.0; // ৮০%
  int _autonomyDays = 2; // ২ দিন মেঘলা দিনের ব্যাকআপ
  double _peakSunHours = 5.5; // বাংলাদেশের গড় ৫.৫ ঘণ্টা
  double _inverterEfficiency = 90.0; // ৯০%
  double _inverterPf = 0.80; // ০.৮০

  @override
  void initState() {
    super.initState();
    // মোট লোড অনুযায়ী স্বয়ংক্রিয়ভাবে BCSIR স্ট্যান্ডার্ড ভোল্টেজ নির্বাচন
    final totalWh = widget.appliances.fold(0.0, (sum, item) => sum + item.dailyEnergyWh);
    if (totalWh < 1500) {
      _systemVoltage = 12.0;
    } else if (totalWh <= 2500) {
      _systemVoltage = 24.0;
    } else if (totalWh <= 4000) {
      _systemVoltage = 48.0;
    } else {
      _systemVoltage = 240.0;
    }
  }

  /// হিসাব সম্পন্ন করে রেজাল্ট স্ক্রিনে যাওয়া
  void _calculateAndProceed() {
    final double? pmax = double.tryParse(_pmaxController.text);
    final double? voc = double.tryParse(_vocController.text);
    final double? isc = double.tryParse(_iscController.text);
    final double? batteryAh = double.tryParse(_batteryAhController.text);

    if (pmax == null || voc == null || isc == null || batteryAh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সবগুলো ঘরে সঠিক সংখ্যা দিন'), backgroundColor: Colors.red),
      );
      return;
    }

    final params = SolarParameters(
      systemVoltage: _systemVoltage,
      panelPmax: pmax,
      panelVoc: voc,
      panelIsc: isc,
      batteryAh: batteryAh,
      batteryEfficiency: _batteryEfficiency / 100,
      batteryDod: _batteryDod / 100,
      daysOfAutonomy: _autonomyDays,
      peakSunHours: _peakSunHours,
      inverterEfficiency: _inverterEfficiency / 100,
      inverterPowerFactor: _inverterPf,
    );

    // BCSIR সোলার ইঞ্জিন রান করা
    final result = SolarEngine.calculate(
      appliances: widget.appliances,
      params: params,
    );

    // রেজাল্ট পেজে নিয়ে যাওয়া
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          result: result,
          params: params,
          appliances: widget.appliances,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('ডিজাইন প্যারামিটার (Parameters)'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // নোটিশ কার্ড
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF1E40AF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'বিসিএসআইআর (BCSIR)-এর আদর্শ মানগুলো নিজে থেকেই বসানো আছে। প্রয়োজন না হলে পরিবর্তনের দরকার নেই।',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ১. সিস্টেম ভোল্টেজ নির্বাচন
            _buildSectionCard(
              title: '১. সিস্টেম ভোল্টেজ (স্বয়ংক্রিয় নির্বাচিত)',
              icon: Icons.electric_meter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    children: [12.0, 24.0, 48.0, 240.0].map((v) {
                      return ChoiceChip(
                        label: Text('${v.toInt()} V'),
                        selected: _systemVoltage == v,
                        selectedColor: Colors.amber.shade700,
                        labelStyle: TextStyle(
                          color: _systemVoltage == v ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _systemVoltage = v);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '১৫০০ Wh-এর নিচে ১২V এবং ১৫০০-২৫০০ Wh-এর জন্য ২৪V সিস্টেম উপযোগী।',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ২. সোলার প্যানেলের বিবরণ
            _buildSectionCard(
              title: '২. সোলার প্যানেল স্পেসিফিকেশন',
              icon: Icons.solar_power,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pmaxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'পাওয়ার (Pmax Wp)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _vocController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'ভোল্টেজ (Voc V)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _iscController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'কারেন্ট (Isc A)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'প্যানেলের পেছনের স্টিকার দেখে এই মানগুলো দেওয়া যায়। (ডিফল্ট: 150W)',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ৩. ব্যাটারি সেটিংস
            _buildSectionCard(
              title: '৩. ব্যাটারি স্পেসিফিকেশন ও ব্যাকআপ',
              icon: Icons.battery_charging_full,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _batteryAhController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'প্রতি ব্যাটারির ধারণক্ষমতা (Ah)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('মেঘলা দিনের ব্যাকআপ: $_autonomyDays দিন', style: const TextStyle(fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (_autonomyDays > 1) setState(() => _autonomyDays--);
                            },
                          ),
                          Text('$_autonomyDays', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              if (_autonomyDays < 5) setState(() => _autonomyDays++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('ব্যাটারির ব্যবহারযোগ্য অংশ (DoD): ${_batteryDod.toInt()}%'),
                  Slider(
                    value: _batteryDod,
                    min: 40,
                    max: 80,
                    divisions: 8,
                    activeColor: Colors.amber.shade700,
                    onChanged: (v) => setState(() => _batteryDod = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ৪. রোদ ও ইনভার্টার
            _buildSectionCard(
              title: '৪. পিক সান-আওয়ার ও ইনভার্টার',
              icon: Icons.wb_sunny,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('দৈনিক গড় রোদ ঘণ্টা: ${_peakSunHours.toStringAsFixed(1)} ঘণ্টা (বাংলাদেশে সাধারণত ৫.৫)'),
                  Slider(
                    value: _peakSunHours,
                    min: 3.5,
                    max: 7.0,
                    divisions: 7,
                    activeColor: Colors.amber.shade700,
                    onChanged: (v) => setState(() => _peakSunHours = v),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ইনভার্টার দক্ষতা: ${_inverterEfficiency.toInt()}%'),
                      Text('পাওয়ার ফ্যাক্টর: ${_inverterPf.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _calculateAndProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F4E79),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('হিসাব সম্পন্ন করুন (Calculate) ➔', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber.shade800, size: 22),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 6),
            child,
          ],
        ),
      ),
    );
  }
}