import 'package:flutter/material.dart';

/// প্রতিটি প্রিসেট সরঞ্জামের মডেল
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

/// পুরোনো BCSIR এবং আধুনিক গৃহস্থালি বিদ্যুতের সমন্বয়ে তৈরি সমৃদ্ধ তালিকা
class AppliancePresets {
  // সকল ক্যাটাগরি
  static const List<String> categories = [
    'Light',
    'Fan',
    'Television',
    'Refrigerator',
    'Air Cooler',
    'Computer',
    'Cooker',
    'Blender',
    'Oven',
    'Pump',
    'Others',
  ];

  // বিস্তারিত সরঞ্জামের তালিকা
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
      defaultHours: 12, // কম্প্রেসর চলার গড় সময়
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

    // --- এয়ারকুলার ও এসি (Air Cooler & AC) ---
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

    // --- কম্পিউটার ও ল্যাপটপ ---
    PresetItem(
      id: 'laptop',
      nameBn: 'ল্যাপটপ',
      nameEn: 'Laptop',
      category: 'Computer',
      defaultWatt: 65,
      defaultHours: 5,
      icon: Icons.laptop_chromebook,
    ),
    PresetItem(
      id: 'desktop_pc',
      nameBn: 'ডেস্কটপ কম্পিউটার',
      nameEn: 'Desktop Computer',
      category: 'Computer',
      defaultWatt: 150,
      defaultHours: 5,
      icon: Icons.computer,
    ),

    // --- কিচেন ও অন্যান্য ---
    PresetItem(
      id: 'blender',
      nameBn: 'ব্লেন্ডার / মিক্সার',
      nameEn: 'Blender / Mixer',
      category: 'Blender',
      defaultWatt: 500,
      defaultHours: 0.5,
      icon: Icons.blender,
    ),
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
      id: 'water_pump_half_hp',
      nameBn: '০.৫ ঘোড়া পানির মোটর',
      nameEn: '0.5 HP Water Pump',
      category: 'Pump',
      defaultWatt: 375,
      defaultHours: 1.0,
      icon: Icons.water_drop,
    ),
    PresetItem(
      id: 'others_custom',
      nameBn: 'অন্যান্য (কাস্টম)',
      nameEn: 'Others (Custom)',
      category: 'Others',
      defaultWatt: 100,
      defaultHours: 2,
      icon: Icons.devices_other,
    ),
  ];
}