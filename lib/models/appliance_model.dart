/// বাসা-বাড়ির প্রতিটি বৈদ্যুতিক সরঞ্জামের (লোড) ডেটা মডেল
class ApplianceModel {
  final String id;           // প্রতিটি আইটেমকে আলাদা চেনার আইডি (মুছে ফেলা বা এডিট করার জন্য)
  final String name;         // সরঞ্জামের নাম (যেমন: সিলিং ফ্যান, এলইডি বাল্ব)
  final String category;     // ক্যাটাগরি (Fan, Light, TV, Fridge ইত্যাদি)
  final double watt;         // একটি সরঞ্জামের ওয়াট (W)
  final int quantity;        // কতটি সরঞ্জাম রয়েছে (সংখ্যা)
  final double usageHours;   // দৈনিক ব্যবহারের সময় (ঘণ্টা)
  final bool isAc;           // বিদ্যুৎ উৎস: true হলে AC, false হলে DC

  ApplianceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.watt,
    required this.quantity,
    required this.usageHours,
    this.isAc = true, // ডিফল্টভাবে AC লোড ধরা হয়েছে
  });

  /// একসাথে সবগুলো ডিভাইস চললে সর্বোচ্চ কত ওয়াট হবে (Peak Watt)
  /// এটি আমাদের ইনভার্টারের সাইজ ঠিক করতে কাজে লাগবে
  double get totalPeakWatt => watt * quantity;

  /// সারাদিনে এই ডিভাইসটি মোট কত ওয়াট-ঘণ্টা বিদ্যুৎ খরচ করবে
  /// এটি আমাদের সোলার প্যানেল ও ব্যাটারির সাইজ ঠিক করতে কাজে লাগবে
  double get dailyEnergyWh => watt * quantity * usageHours;

  /// ডেটা আপডেট করার সুবিধার্থে copyWith মেথড
  ApplianceModel copyWith({
    String? id,
    String? name,
    String? category,
    double? watt,
    int? quantity,
    double? usageHours,
    bool? isAc,
  }) {
    return ApplianceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      watt: watt ?? this.watt,
      quantity: quantity ?? this.quantity,
      usageHours: usageHours ?? this.usageHours,
      isAc: isAc ?? this.isAc,
    );
  }
}R