import 'package:flutter/material.dart';

class PresetItem {
  final String id;
  final String nameBn;
  final String nameEn;
  final String category;
  final double defaultWatt;
  final double defaultHours;
  final bool defaultIsAc;
  final IconData icon;

  const PresetItem({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.category,
    required this.defaultWatt,
    required this.defaultHours,
    this.defaultIsAc = true,
    required this.icon,
  });
}

class AppliancePresets {
  // সকল ১২টি মূল ক্যাটাগরি
  static const List<Map<String, dynamic>> categories = [
    {'key': 'Light', 'name': 'লাইট', 'icon': Icons.lightbulb_outline},
    {'key': 'Fan', 'name': 'ফ্যান', 'icon': Icons.mode_fan_off_outlined},
    {'key': 'Television', 'name': 'টিভি', 'icon': Icons.tv},
    {'key': 'Refrigerator', 'name': 'ফ্রিজ', 'icon': Icons.kitchen},
    {'key': 'Air Cooler', 'name': 'এসি / কুলার', 'icon': Icons.severe_cold},
    {'key': 'Computer', 'name': 'কম্পিউটার', 'icon': Icons.computer},
    {'key': 'Laptop', 'name': 'ল্যাপটপ', 'icon': Icons.laptop_chromebook},
    {'key': 'Printer', 'name': 'প্রিন্টার', 'icon': Icons.print},
    {'key': 'Cooker', 'name': 'কুকার', 'icon': Icons.soup_kitchen},
    {'key': 'Oven', 'name': 'ওভেন', 'icon': Icons.microwave},
    {'key': 'Blender', 'name': 'ব্লেন্ডার', 'icon': Icons.blender},
    {'key': 'Pump', 'name': 'পানির পাম্প', 'icon': Icons.water_drop},
    {'key': 'Others', 'name': 'অন্যান্য', 'icon': Icons.devices_other},
  ];

  static const List<PresetItem> items = [
    // --- লাইট (Light) ---
    PresetItem(
      id: 'led_9w',
      nameBn: 'এলইডি বাল্ব (৯ ওয়াট)',
      nameEn: 'LED Bulb (9W)',
      category: 'Light',
      defaultWatt: 9,
      defaultHours: 6,
      icon: Icons.lightbulb_outline,
    ),
    PresetItem(
      id: 'led_15w',
      nameBn: 'এলইডি বাল্ব (১৫ ওয়াট)',
      nameEn: 'LED Bulb (15W)',
      category: 'Light',
      defaultWatt: 15,
      defaultHours: 6,
      icon: Icons.lightbulb,
    ),
    PresetItem(
      id: 'tube_light',
      nameBn: 'টিউব লাইট (৪ ফিট)',
      nameEn: 'Tube Light (4ft)',
      category: 'Light',
      defaultWatt: 36,
      defaultHours: 6,
      icon: Icons.linear_scale,
    ),
    PresetItem(
      id: 'dc_light',
      nameBn: 'ডিসি ১২ ভোল্ট লাইট',
      nameEn: '12V DC Light',
      category: 'Light',
      defaultWatt: 7,
      defaultHours: 6,
      defaultIsAc: false,
      icon: Icons.wb_incandescent,
    ),

    // --- ফ্যান (Fan) ---
    PresetItem(
      id: 'ceiling_fan',
      nameBn: 'সাধারণ সিলিং ফ্যান',
      nameEn: 'Ceiling Fan (Standard)',
      category: 'Fan',
      defaultWatt: 75,
      defaultHours: 10,
      icon: Icons.mode_fan_off,
    ),
    PresetItem(
      id: 'bldc_fan',
      nameBn: 'বিএলডিসি ফ্যান (সাশ্রয়ী)',
      nameEn: 'BLDC Ceiling Fan',
      category: 'Fan',
      defaultWatt: 35,
      defaultHours: 10,
      icon: Icons.wind_power,
    ),
    PresetItem(
      id: 'table_fan',
      nameBn: 'টেবিল ফ্যান',
      nameEn: 'Table Fan',
      category: 'Fan',
      defaultWatt: 50,
      defaultHours: 8,
      icon: Icons.air,
    ),
    PresetItem(
      id: 'dc_fan',
      nameBn: 'ডিসি ১২ ভোল্ট ফ্যান',
      nameEn: '12V DC Fan',
      category: 'Fan',
      defaultWatt: 20,
      defaultHours: 10,
      defaultIsAc: false,
      icon: Icons.toys_outlined,
    ),

    // --- টেলিভিশন (Television) ---
    PresetItem(
      id: 'led_tv_32',
      nameBn: '৩২" এলইডি টিভি',
      nameEn: '32" LED TV',
      category: 'Television',
      defaultWatt: 45,
      defaultHours: 4,
      icon: Icons.tv,
    ),
    PresetItem(
      id: 'led_tv_43',
      nameBn: '৪৩" এলইডি টিভি',
      nameEn: '43" LED TV',
      category: 'Television',
      defaultWatt: 75,
      defaultHours: 4,
      icon: Icons.desktop_windows,
    ),

    // --- ফ্রিজ (Refrigerator) ---
    PresetItem(
      id: 'fridge_inverter',
      nameBn: 'ইনভার্টার ফ্রিজ',
      nameEn: 'Inverter Refrigerator',
      category: 'Refrigerator',
      defaultWatt: 120,
      defaultHours: 12,
      icon: Icons.kitchen,
    ),
    PresetItem(
      id: 'fridge_normal',
      nameBn: 'সাধারণ ফ্রিজ (নন-ইনভার্টার)',
      nameEn: 'Standard Refrigerator',
      category: 'Refrigerator',
      defaultWatt: 180,
      defaultHours: 12,
      icon: Icons.kitchen_outlined,
    ),
    PresetItem(
      id: 'deep_fridge',
      nameBn: 'ডিপ ফ্রিজ',
      nameEn: 'Deep Freezer',
      category: 'Refrigerator',
      defaultWatt: 220,
      defaultHours: 12,
      icon: Icons.ac_unit,
    ),

    // --- এসি ও এয়ারকুলার (Air Cooler & AC) ---
    PresetItem(
      id: 'air_cooler',
      nameBn: 'এয়ার কুলার',
      nameEn: 'Air Cooler',
      category: 'Air Cooler',
      defaultWatt: 150,
      defaultHours: 6,
      icon: Icons.hvac,
    ),
    PresetItem(
      id: 'ac_1_ton',
      nameBn: '১ টন ইনভার্টার এসি',
      nameEn: '1 Ton Inverter AC',
      category: 'Air Cooler',
      defaultWatt: 1000,
      defaultHours: 6,
      icon: Icons.severe_cold,
    ),

    // --- কম্পিউটার (Computer) ---
    PresetItem(
      id: 'desktop_pc',
      nameBn: 'ডেস্কটপ কম্পিউটার',
      nameEn: 'Desktop Computer',
      category: 'Computer',
      defaultWatt: 150,
      defaultHours: 6,
      icon: Icons.computer,
    ),
    PresetItem(
      id: 'gaming_pc',
      nameBn: 'গেমিং পিসি',
      nameEn: 'Gaming PC',
      category: 'Computer',
      defaultWatt: 350,
      defaultHours: 4,
      icon: Icons.sports_esports,
    ),

    // --- ল্যাপটপ (Laptop) ---
    PresetItem(
      id: 'laptop_standard',
      nameBn: 'সাধারণ ল্যাপটপ',
      nameEn: 'Laptop',
      category: 'Laptop',
      defaultWatt: 65,
      defaultHours: 6,
      icon: Icons.laptop_chromebook,
    ),
    PresetItem(
      id: 'tablet_device',
      nameBn: 'ট্যাবলেট',
      nameEn: 'Tablet',
      category: 'Laptop',
      defaultWatt: 25,
      defaultHours: 4,
      icon: Icons.tablet_mac,
    ),

    // --- প্রিন্টার (Printer) ---
    PresetItem(
      id: 'printer_inkjet',
      nameBn: 'ইঙ্কজেট প্রিন্টার',
      nameEn: 'Inkjet Printer',
      category: 'Printer',
      defaultWatt: 30,
      defaultHours: 1,
      icon: Icons.print,
    ),
    PresetItem(
      id: 'printer_laser',
      nameBn: 'লেজার প্রিন্টার',
      nameEn: 'Laser Printer',
      category: 'Printer',
      defaultWatt: 300,
      defaultHours: 0.5,
      icon: Icons.print_outlined,
    ),

    // --- কুকার (Cooker) ---
    PresetItem(
      id: 'induction_cooker',
      nameBn: 'ইন্ডাকশন কুকার',
      nameEn: 'Induction Cooker',
      category: 'Cooker',
      defaultWatt: 1500,
      defaultHours: 1.5,
      icon: Icons.soup_kitchen,
    ),
    PresetItem(
      id: 'electric_cooker',
      nameBn: 'রাইস কুকার / ইলেকট্রিক কুকার',
      nameEn: 'Rice Cooker',
      category: 'Cooker',
      defaultWatt: 700,
      defaultHours: 1.0,
      icon: Icons.rice_bowl,
    ),

    // --- ওভেন (Oven) - [ফিক্স করা হলো!] ---
    PresetItem(
      id: 'oven_microwave',
      nameBn: 'মাইক্রোওয়েভ ওভেন',
      nameEn: 'Microwave Oven',
      category: 'Oven',
      defaultWatt: 1200,
      defaultHours: 0.5,
      icon: Icons.microwave,
    ),
    PresetItem(
      id: 'oven_electric',
      nameBn: 'ইলেকট্রিক ওভেন (বেকিং)',
      nameEn: 'Electric Oven',
      category: 'Oven',
      defaultWatt: 1500,
      defaultHours: 0.5,
      icon: Icons.wb_shade,
    ),

    // --- ব্লেন্ডার (Blender) ---
    PresetItem(
      id: 'blender_mixer',
      nameBn: 'ব্লেন্ডার ও মিক্সার',
      nameEn: 'Blender & Mixer',
      category: 'Blender',
      defaultWatt: 500,
      defaultHours: 0.5,
      icon: Icons.blender,
    ),
    PresetItem(
      id: 'blender_grinder',
      nameBn: 'গ্রাইন্ডার / মশলা পেষা',
      nameEn: 'Grinder',
      category: 'Blender',
      defaultWatt: 750,
      defaultHours: 0.25,
      icon: Icons.grain,
    ),

    // --- পানির পাম্প (Pump) ---
    PresetItem(
      id: 'water_pump_half_hp',
      nameBn: '০.৫ ঘোড়া পানির মোটর',
      nameEn: '0.5 HP Water Pump',
      category: 'Pump',
      defaultWatt: 375,
      defaultHours: 1.0,
      icon: Icons.water_drop,
    ),
    PresetItem(
      id: 'water_pump_1_hp',
      nameBn: '১ ঘোড়া পানির মোটর',
      nameEn: '1.0 HP Water Pump',
      category: 'Pump',
      defaultWatt: 750,
      defaultHours: 1.0,
      icon: Icons.water,
    ),

    // --- অন্যান্য (Others) ---
    PresetItem(
      id: 'others_custom',
      nameBn: 'অন্যান্য সরঞ্জাম (কাস্টম)',
      nameEn: 'Others (Custom)',
      category: 'Others',
      defaultWatt: 100,
      defaultHours: 2.0,
      icon: Icons.devices_other,
    ),
  ];
}