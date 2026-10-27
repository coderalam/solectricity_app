import '../models/appliance_model.dart';
import '../models/solar_result_model.dart';

/// বিসিএসআইআর (BCSIR)-এর আসল ফর্মুলায় তৈরি সোলার ক্যালকুলেশন ইঞ্জিন
class SolarEngine {
  /// প্রধান ক্যালকুলেশন মেথড
  static SolarCalculationResult calculate({
    required List<ApplianceModel> appliances,
    required SolarParameters params,
  }) {
    double totalAcWh = 0.0;
    double totalDcWh = 0.0;
    double peakAcWatts = 0.0;

    // ১. সবগুলো সরঞ্জামের মোট লোড ও পিক ওয়াট বের করা
    for (var item in appliances) {
      if (item.isAc) {
        totalAcWh += item.dailyEnergyWh;
        peakAcWatts += item.totalPeakWatt;
      } else {
        totalDcWh += item.dailyEnergyWh;
      }
    }

    // ২. ব্যাটারি লোড (BL - Battery Load Wh)
    // ইনভার্টারের অপচয় সমন্বয় করে ব্যাটারি থেকে মোট শক্তি
    final double bl = (totalAcWh / params.inverterEfficiency) + totalDcWh;

    // ৩. দৈনিক কারেন্ট চাহিদা (Ed - Daily Ah)
    final double ed = bl / params.systemVoltage;

    // ৪. সোলার প্যানেল হিসাব (PVs, PVt, PVp)
    // সিরিজে কয়টি প্যানেল (PVs)
    final int pvs = (params.systemVoltage / params.panelVoc).ceil();

    // মোট কয়টি প্যানেল লাগবে (PVt)
    final int pvt = (bl / (params.peakSunHours * params.panelPmax)).ceil();

    // প্যারালালে কয়টি প্যানেল (PVp)
    final int pvp = (pvt / (pvs > 0 ? pvs : 1)).ceil();

    // গ্রিড সেটআপ নিখুঁত কি না যাচাই (PVs * PVp == PVt)
    final bool isConfigValid = (pvs * pvp) == pvt;

    // মোট সোলার প্যানেল ক্ষমতা (Wp)
    final double pva = pvt * params.panelPmax;

    // ৫. ব্যাটারি ক্যাপাসিটি হিসাব (Bs - Battery Ah)
    final double bs = ed * (params.daysOfAutonomy / params.batteryDod);
    final int batteryCount = (bs / params.batteryAh).ceil();

    // ৬. চার্জ কন্ট্রোলার কারেন্ট (Cc - Amperes)
    final double cc = 1.25 * (params.panelIsc * pvp);

    // ৭. ইনভার্টারের ক্ষমতা (Is - VA)
    final double isVA = 1.5 * (peakAcWatts / params.inverterPowerFactor);

    // ৮. ২৪টি ছবির মধ্য থেকে সঠিক ওয়্যারিং ডায়াগ্রামের নাম নির্বাচন
    final String diagramName = _getDiagramName(
      batteryCount: batteryCount,
      pvs: pvs,
      pvp: pvp,
      hasAc: totalAcWh > 0,
      hasDc: totalDcWh > 0,
    );

    return SolarCalculationResult(
      totalAcWh: totalAcWh,
      totalDcWh: totalDcWh,
      totalEnergyWh: totalAcWh + totalDcWh,
      totalSolarWattNeeded: pva,
      totalPanels: pvt,
      panelsInSeries: pvs,
      panelsInParallel: pvp,
      totalBatteryAh: bs,
      totalBatteries: batteryCount,
      chargeControllerAmps: cc,
      inverterVA: isVA,
      schematicDiagramName: diagramName,
      isConfigurationValid: isConfigValid,
    );
  }

  /// BCSIR-এর লজিক অনুযায়ী সঠিক ডায়াগ্রামের ফাইলনেম রিটার্ন করে
  static String _getDiagramName({
    required int batteryCount,
    required int pvs,
    required int pvp,
    required bool hasAc,
    required bool hasDc,
  }) {
    // ব্যাটারি ১টির বেশি হলে প্রিফিক্স 'B', নাহলে খালি
    String prefix = batteryCount > 1 ? "B" : "";

    // সোলার প্যানেল সংযোগের ধরন (Single, Series, Parallel, নাকি Series-Parallel)
    String pvType = "";
    if (pvs == 1 && pvp == 1) {
      pvType = "Si";
    } else if (pvs > 1 && pvp == 1) {
      pvType = "S";
    } else if (pvs == 1 && pvp > 1) {
      pvType = "P";
    } else {
      pvType = "SP";
    }

    // লোডের ধরন (এসি, ডিসি, নাকি উভয়ই)
    String loadType = "";
    if (hasAc && hasDc) {
      loadType = "AcDc";
    } else if (hasAc) {
      loadType = "Ac";
    } else {
      loadType = "Dc";
    }

    // উদাহরণ: SPAcDc.png বা BSAc.png
    return "$prefix$pvType$loadType.png";
  }
}