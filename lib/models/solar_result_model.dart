/// সোলার সিস্টেমের ইনপুট প্যারামিটারসমূহ (BCSIR-এর অফিশিয়াল মানসহ)
class SolarParameters {
  final double systemVoltage;      // সিস্টেম ভোল্টেজ (12V, 24V, 48V বা 240V)
  final double panelPmax;          // একটি সোলার প্যানেলের সর্বোচ্চ ক্ষমতা (Wp, যেমন: 150W)
  final double panelVoc;           // সোলার প্যানেল ভোল্টেজ (V)
  final double panelIsc;           // সোলার প্যানেল শর্ট-সার্কিট কারেন্ট (A)
  final double batteryAh;          // প্রতি ব্যাটারির ধারণক্ষমতা (Ah, যেমন: 100Ah)
  final double batteryEfficiency;  // ব্যাটারি কর্মক্ষমতা (ডিফল্ট ৮০% বা 0.80)
  final double batteryDod;         // ব্যাটারি কত অংশ ব্যবহারযোগ্য (DoD ৭০% বা 0.70)
  final int daysOfAutonomy;        // কত মেঘলা দিনের ব্যাকআপ থাকবে (ডিফল্ট ২ দিন)
  final double peakSunHours;       // বাংলাদেশে দৈনিক গড়পড়তা রোদ ঘণ্টা (ডিফল্ট ৫.৫ ঘণ্টা)
  final double inverterEfficiency; // ইনভার্টারের কর্মক্ষমতা (ডিফল্ট ৯০% বা 0.90)
  final double inverterPowerFactor;// ইনভার্টারের পাওয়ার ফ্যাক্টর (ডিফল্ট ০.৮০)

  SolarParameters({
    this.systemVoltage = 12.0,
    this.panelPmax = 150.0,
    this.panelVoc = 21.0,
    this.panelIsc = 8.5,
    this.batteryAh = 100.0,
    this.batteryEfficiency = 0.80,
    this.batteryDod = 0.70,
    this.daysOfAutonomy = 2,
    this.peakSunHours = 5.5,
    this.inverterEfficiency = 0.90,
    this.inverterPowerFactor = 0.80,
  });

  /// ডেটা পরিবর্তনের সুবিধার জন্য copyWith
  SolarParameters copyWith({
    double? systemVoltage,
    double? panelPmax,
    double? panelVoc,
    double? panelIsc,
    double? batteryAh,
    double? batteryEfficiency,
    double? batteryDod,
    int? daysOfAutonomy,
    double? peakSunHours,
    double? inverterEfficiency,
    double? inverterPowerFactor,
  }) {
    return SolarParameters(
      systemVoltage: systemVoltage ?? this.systemVoltage,
      panelPmax: panelPmax ?? this.panelPmax,
      panelVoc: panelVoc ?? this.panelVoc,
      panelIsc: panelIsc ?? this.panelIsc,
      batteryAh: batteryAh ?? this.batteryAh,
      batteryEfficiency: batteryEfficiency ?? this.batteryEfficiency,
      batteryDod: batteryDod ?? this.batteryDod,
      daysOfAutonomy: daysOfAutonomy ?? this.daysOfAutonomy,
      peakSunHours: peakSunHours ?? this.peakSunHours,
      inverterEfficiency: inverterEfficiency ?? this.inverterEfficiency,
      inverterPowerFactor: inverterPowerFactor ?? this.inverterPowerFactor,
    );
  }
}

/// ক্যালকুলেশনের চূড়ান্ত ফলাফল মডেল
class SolarCalculationResult {
  final double totalAcWh;            // এসি লোডের মোট দৈনিক Wh
  final double totalDcWh;            // ডিসি লোডের মোট দৈনিক Wh
  final double totalEnergyWh;        // মোট প্রয়োজনীয় শক্তি (Wh)
  final double totalSolarWattNeeded; // মোট সোলার প্যানেল ক্ষমতা (Wp)
  final int totalPanels;             // মোট সোলার প্যানেল সংখ্যা (PVt)
  final int panelsInSeries;          // সিরিজে কয়টি প্যানেল (PVs)
  final int panelsInParallel;        // প্যারালালে কয়টি প্যানেল (PVp)
  final double totalBatteryAh;       // মোট ব্যাটারি ধারণক্ষমতা (Ah)
  final int totalBatteries;          // মোট ব্যাটারির সংখ্যা
  final double chargeControllerAmps; // চার্জ কন্ট্রোলারের অ্যাম্পিয়ার (A)
  final double inverterVA;           // ইনভার্টারের সাইজ (VA)
  final String schematicDiagramName; // ২৪টি ছবির মধ্যে কোনটি দেখাবে (যেমন: SPAcDc.png)
  final bool isConfigurationValid;   // গ্রিড সেটআপ সঠিক আছে কি না

  SolarCalculationResult({
    required this.totalAcWh,
    required this.totalDcWh,
    required this.totalEnergyWh,
    required this.totalSolarWattNeeded,
    required this.totalPanels,
    required this.panelsInSeries,
    required this.panelsInParallel,
    required this.totalBatteryAh,
    required this.totalBatteries,
    required this.chargeControllerAmps,
    required this.inverterVA,
    required this.schematicDiagramName,
    required this.isConfigurationValid,
  });
}