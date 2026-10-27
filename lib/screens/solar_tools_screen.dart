import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';

class SolarToolsScreen extends StatefulWidget {
  final int initialTabIndex; // 0 = Compass, 1 = Leveler, 2 = Guide

  const SolarToolsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SolarToolsScreen> createState() => _SolarToolsScreenState();
}

class _SolarToolsScreenState extends State<SolarToolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // সেন্সর ভ্যালু
  double _compassHeading = 180.0;
  double _tiltAngle = 25.0;

  // সেন্সর স্ট্যাটাস
  bool _hasCompassSensor = false;
  bool _hasAccelerometer = false;
  bool _hasVibratedSouth = false;
  bool _hasVibratedAngle = false;

  StreamSubscription? _compassSubscription;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // হার্ডওয়্যার সেন্সর চালু করা
    _initSensors();
  }

  void _initSensors() {
    // ১. কম্পাস ম্যাগনেটোমিটার সেন্সর লিসেনার
    if (!kIsWeb) {
      _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
        if (event.heading != null && mounted) {
          setState(() {
            _hasCompassSensor = true;
            // 0 - 360 ডিগ্রিতে নরমাল করা
            _compassHeading = (event.heading! < 0) ? event.heading! + 360 : event.heading!;
          });

          // ঠিক ১৮০° দক্ষিণমুখী হলে ভাইব্রেশন ট্রিগার
          final isSouth = (_compassHeading >= 175 && _compassHeading <= 185);
          if (isSouth && !_hasVibratedSouth) {
            HapticFeedback.mediumImpact();
            _hasVibratedSouth = true;
          } else if (!isSouth) {
            _hasVibratedSouth = false;
          }
        }
      });
    }

    // ২. অ্যাক্সিলেরোমিটার (Tilt Angle) লিসেনার
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (mounted) {
        // ফোনটি প্যানেলের ওপর সমতলে রাখলে মাধ্যাকর্ষণ ভেক্টর দিয়ে টিল্ট কোণ নির্ধারণ
        final double magnitude = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (magnitude > 0) {
          // অনুভূমিক সমতল থেকে কোণ (Degrees)
          double inclination = math.acos((event.z.abs() / magnitude).clamp(-1.0, 1.0)) * (180.0 / math.pi);

          setState(() {
            _hasAccelerometer = true;
            _tiltAngle = inclination;
          });

          // আদর্শ ২৫° কোণে পৌঁছালে ভাইব্রেশন
          final isIdealAngle = (_tiltAngle >= 24 && _tiltAngle <= 26);
          if (isIdealAngle && !_hasVibratedAngle) {
            HapticFeedback.mediumImpact();
            _hasVibratedAngle = true;
          } else if (!isIdealAngle) {
            _hasVibratedAngle = false;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('ইনস্টলার টুলস ও গাইড (Real-time)'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.explore_rounded), text: 'লাইভ কম্পাস'),
            Tab(icon: Icon(Icons.architecture_rounded), text: 'লাইভ লেভেলার'),
            Tab(icon: Icon(Icons.menu_book_rounded), text: 'রক্ষণাবেক্ষণ গাইড'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveCompassView(),
          _buildLiveLevelerView(),
          _buildMaintenanceGuideView(),
        ],
      ),
    );
  }

  // ==========================================
  // ১. রিয়েল-টাইম সোলার কম্পাস
  // ==========================================
  Widget _buildLiveCompassView() {
    final isSouth = (_compassHeading >= 175 && _compassHeading <= 185);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildSensorStatusBadge(
            isLive: _hasCompassSensor,
            sensorName: 'ম্যাগনেটোমিটার (কম্পাস)',
          ),
          const SizedBox(height: 16),

          _buildToolHeader(
            title: 'সোলার কম্পাস (দক্ষিণ দিক নির্ধারণ)',
            description: 'ফোনটি অনুভূমিকভাবে হাতে রেখে ডানে বা বামে ঘোরান। ১৮০° বরাবর আসলে কাঁটা দক্ষিণে স্থির হবে এবং ফোন ভাইব্রেট করবে।',
          ),
          const SizedBox(height: 24),

          // রিয়েল-টাইম ডায়াল
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(
                    color: isSouth ? Colors.green.shade600 : Colors.amber.shade700,
                    width: 4,
                  ),
                ),
              ),

              // ঘূর্ণায়মান কাঁটা
              Transform.rotate(
                angle: ((360 - _compassHeading) * (math.pi / 180)),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Icon(Icons.navigation_rounded, color: Colors.red, size: 36),
                          Text('N (উত্তর)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.red)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('S (দক্ষিণ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green.shade800)),
                          Icon(Icons.wb_sunny_rounded, color: Colors.amber.shade800, size: 36),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // সেন্ট্রাল ডিগ্রি টেক্সট
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Text(
                  '${_compassHeading.toInt()}°',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSouth ? Colors.green.shade700 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // পিসি/ব্রাউজারে টেস্টিং স্লাইডার (মোবাইলে সেন্সর লাইভ কাজ করবে)
          if (!_hasCompassSensor) ...[
            Text('কম্পিউটার টেস্ট স্লাইডার: ${_compassHeading.toInt()}°', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Slider(
              value: _compassHeading,
              min: 0,
              max: 360,
              activeColor: isSouth ? Colors.green.shade600 : Colors.amber.shade700,
              onChanged: (val) => setState(() => _compassHeading = val),
            ),
          ],

          const SizedBox(height: 10),

          // স্ট্যাটাস বক্স
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSouth ? Colors.green.shade50 : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSouth ? Colors.green.shade300 : Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(isSouth ? Icons.check_circle_rounded : Icons.explore, color: isSouth ? Colors.green.shade800 : Colors.amber.shade900),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isSouth
                        ? 'পারফেক্ট! দিক একদম নিখুঁত দক্ষিণমুখী (১৮০° South)। এই দিকে প্যানেল বসালে সর্বোচ্চ সূর্যালোক শোষিত হবে।'
                        : 'প্যানেলের মুখ ঠিক ১৮০° (South/দক্ষিণ) বরাবর আনুন।',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSouth ? Colors.green.shade900 : Colors.amber.shade900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ২. রিয়েল-টাইম সারফেস লেভেলার (২৫° টিল্ট অ্যাঙ্গেল)
  // ==========================================
  Widget _buildLiveLevelerView() {
    final isIdealAngle = (_tiltAngle >= 24 && _tiltAngle <= 26);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildSensorStatusBadge(
            isLive: _hasAccelerometer,
            sensorName: 'অ্যাক্সিলেরোমিটার (Gravity Sensor)',
          ),
          const SizedBox(height: 16),

          _buildToolHeader(
            title: 'লাইভ সারফেস লেভেলার (২৫° টিল্ট অ্যাঙ্গেল)',
            description: 'ফোনটি সোলার প্যানেল বা ফ্রেমের ওপর সমতলে শুইয়ে রাখুন। এটি রিয়েল-টাইমে পৃষ্ঠের খাঁড়া কোণ পরিমাপ করবে।',
          ),
          const SizedBox(height: 24),

          // ভিজ্যুয়াল লাইভ বাবল লেভেলার মিটার
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isIdealAngle ? Colors.green.shade500 : Colors.amber.shade600, width: 2.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isIdealAngle ? Colors.green.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'আদর্শ বিসিএসআইআর মান: ২৫° কোণ',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isIdealAngle ? Colors.green.shade900 : Colors.black87),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '${_tiltAngle.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: isIdealAngle ? Colors.green.shade700 : Colors.amber.shade900,
                      ),
                    ),
                    Text(
                      isIdealAngle
                          ? '🎯 নিখুঁত ২৫° টিল্ট কোণ অর্জিত!'
                          : (_tiltAngle < 24 ? 'প্যানেল আরও খাড়া করুন (বর্তমানে খুব নিচু)' : 'প্যানেল আরও শোয়ান (বর্তমানে খুব খাড়া)'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isIdealAngle ? Colors.green.shade800 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ব্রাউজার টেস্টিং স্লাইডার
          if (!_hasAccelerometer) ...[
            Text('কম্পিউটার টেস্ট স্লাইডার: ${_tiltAngle.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Slider(
              value: _tiltAngle.clamp(0.0, 90.0),
              min: 0,
              max: 90,
              activeColor: isIdealAngle ? Colors.green.shade600 : Colors.amber.shade700,
              onChanged: (val) => setState(() => _tiltAngle = val),
            ),
          ],

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.help_outline_rounded, color: Colors.blue, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'ইনস্টলার পরামর্শ: সোলার প্যানেলের যেকোনো একটি মসৃণ কোনায় ফোনটি রাখুন। ২৫° কোণে পৌঁছালে ফোন মৃদু ভাইব্রেট করবে, তখন ফ্রেমের নাট-বোল্ট লক করে দিন।',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ৩. রক্ষণাবেক্ষণ ও স্থাপন গাইড
  // ==========================================
  Widget _buildMaintenanceGuideView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolHeader(
            title: 'সোলার স্থাপন ও রক্ষণাবেক্ষণ নির্দেশিকা',
            description: 'বাংলাদেশ বিজ্ঞান ও শিল্প গবেষণা পরিষদ (BCSIR)-এর অনুমোদিত কারিগরি ব্যবহারবিধি।',
          ),
          const SizedBox(height: 16),

          _buildGuideCard(
            category: '১. সোলার প্যানেল স্থাপন ও যত্ন',
            icon: Icons.solar_power,
            color: Colors.amber.shade800,
            points: [
              'প্যানেলগুলো এমন উঁচু স্থানে দক্ষিণমুখী করে বসাতে হবে যেন সকাল ৮টা থেকে বিকাল ৪টা পর্যন্ত সরাসরি সূর্যের আলো পায়।',
              'প্যানেল ভূমির সাথে ঠিক ২৫° কোণে স্থাপন করতে হবে।',
              'প্রতি মাসে অন্তত একবার নরম ব্রাশ ও পরিষ্কার পানি দিয়ে প্যানেল ধুয়ে নিতে হবে (বর্ষাকালে ধোয়ার প্রয়োজন নেই)।',
              'প্যানেলের পেছনে তারের সংযোগে লাল তার (+) এবং কালো/নীল তার (-) নিশ্চিত করতে হবে।',
            ],
          ),
          const SizedBox(height: 14),

          _buildGuideCard(
            category: '২. ব্যাটারি স্থাপন ও রক্ষণাবেক্ষণ',
            icon: Icons.battery_charging_full,
            color: Colors.green.shade800,
            points: [
              'ব্যাটারি ঘরের ভেতরে শুকনো, ঠান্ডা এবং বাতাস চলাচলের জায়গায় মেঝের ওপর রাখতে হবে।',
              'প্রতি মাসে ব্যাটারির ওপরের অংশ শুকনো কাপড় দিয়ে মুছে ফেলতে হবে।',
              'ব্যাটারির তারের সংযোগস্থলে (Terminals) ময়লা জমলে নরম তারের ব্রাশ দিয়ে পরিষ্কার রাখতে হবে।',
              'ব্যাটারির পানির স্তর নিয়মিত দেখতে হবে। দাগের নিচে নেমে গেলে বাজারে পাওয়া ডিস্টিল্ড ওয়াটার (ব্যাটারির পানি) ভরতে হবে। সাধারণ পানি দেওয়া সম্পূর্ণ নিষিদ্ধ।',
            ],
          ),
          const SizedBox(height: 14),

          _buildGuideCard(
            category: '৩. চার্জ কন্ট্রোলার ও ইনভার্টার',
            icon: Icons.settings_input_component,
            color: Colors.blue.shade800,
            points: [
              'চার্জ কন্ট্রোলার ও ইনভার্টার সবসময় ব্যাটারির কাছাকাছি শুকনো ও আর্দ্রতামুক্ত স্থানে শিশুদের নাগালের বাইরে স্থাপন করতে হবে।',
              'ইনভার্টারের সাথে যন্ত্রপাতি সংযোগের ক্ষেত্রে L/P টার্মিনালে লাল তার এবং N টার্মিনালে কালো তার সংযোগ দিতে হবে।',
              'বর্ষাকালে যাতে ছাদ থেকে তার বেয়ে ঘরের ভেতর কোনো বৃষ্টির পানি না ঢুকতে পারে, সেদিকে বিশেষ নজর রাখতে হবে।',
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // লাইভ সেন্সর স্ট্যাটাস ব্যাজ
  Widget _buildSensorStatusBadge({required bool isLive, required String sensorName}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLive ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isLive ? Colors.green.shade300 : Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isLive ? Icons.sensors_rounded : Icons.laptop_chromebook, size: 16, color: isLive ? Colors.green.shade700 : Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            isLive ? '🔴 $sensorName: লাইভ সক্রিয়' : '💻 ওয়েব প্রিভিউ মোড (মোবাইলে লাইভ সেন্সর চলবে)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isLive ? Colors.green.shade800 : Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolHeader({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required String category,
    required IconData icon,
    required Color color,
    required List<String> points,
  }) {
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
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
              ],
            ),
            const Divider(height: 20),
            Column(
              children: points.map((p) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
                      Expanded(
                        child: Text(p, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.4)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}