import 'package:flutter/material.dart';
import '../models/appliance_model.dart';
import '../core/appliance_presets.dart';
import 'system_parameter_screen.dart';

class LoadSelectionScreen extends StatefulWidget {
  const LoadSelectionScreen({super.key});

  @override
  State<LoadSelectionScreen> createState() => _LoadSelectionScreenState();
}

class _LoadSelectionScreenState extends State<LoadSelectionScreen> {
  final List<ApplianceModel> _appliances = [];

  String _selectedCategory = 'Light';
  PresetItem? _selectedPreset;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wattController = TextEditingController();
  int _quantity = 1;
  double _usageHours = 6.0;
  bool _isAc = true;

  @override
  void initState() {
    super.initState();
    _applyPreset(AppliancePresets.items.first);
  }

  void _applyPreset(PresetItem item) {
    setState(() {
      _selectedPreset = item;
      _selectedCategory = item.category;
      _nameController.text = item.nameBn;
      _wattController.text = item.defaultWatt.toStringAsFixed(0);
      _usageHours = item.defaultHours;
      _isAc = item.defaultIsAc;
      _quantity = 1;
    });
  }

  void _onCategorySelected(String categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
      final matchedItems = AppliancePresets.items.where((it) => it.category == categoryKey).toList();
      if (matchedItems.isNotEmpty) {
        _applyPreset(matchedItems.first);
      } else {
        _selectedPreset = null;
        _nameController.text = categoryKey;
        _wattController.text = '100';
      }
    });
  }

  void _addAppliance() {
    final String name = _nameController.text.trim();
    final double? watt = double.tryParse(_wattController.text.trim());

    if (name.isEmpty) {
      _showSnackbar('অনুগ্রহ করে সরঞ্জামের নাম লিখুন');
      return;
    }
    if (watt == null || watt <= 0) {
      _showSnackbar('সঠিক ওয়াট (Watt) লিখুন');
      return;
    }

    final newItem = ApplianceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: _selectedCategory,
      watt: watt,
      quantity: _quantity,
      usageHours: _usageHours,
      isAc: _isAc,
    );

    setState(() {
      _appliances.add(newItem);
    });

    _showSnackbar('$name সফলভাবে যোগ করা হয়েছে', isSuccess: true);
  }

  void _showSnackbar(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  double get _totalAcWh => _appliances
      .where((item) => item.isAc)
      .fold(0.0, (sum, item) => sum + item.dailyEnergyWh);

  double get _totalDcWh => _appliances
      .where((item) => !item.isAc)
      .fold(0.0, (sum, item) => sum + item.dailyEnergyWh);

  double get _totalWh => _totalAcWh + _totalDcWh;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768; // মোবাইল বনাম ডেস্কটপ রেসপন্সিভ ব্রেকপয়েন্ট

    final availablePresets = AppliancePresets.items
        .where((item) => item.category == _selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('উপকরণ নির্বাচন (Load Selection)'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isDesktop
          ? _buildDesktopLayout(availablePresets)
          : _buildMobileLayout(availablePresets),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// ডেস্কটপ ও ট্যাবলেট লেআউট (বাম পাশে হোভারসহ সাইডবার)
  Widget _buildDesktopLayout(List<PresetItem> availablePresets) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // বাম পাশের সাইড প্যানেল
        Container(
          width: 240,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber.shade50,
                child: Row(
                  children: [
                    Icon(Icons.category_rounded, color: Colors.amber.shade900, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'সরঞ্জাম ক্যাটাগরি',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AppliancePresets.categories.length,
                  itemBuilder: (context, index) {
                    final cat = AppliancePresets.categories[index];
                    final isSelected = cat['key'] == _selectedCategory;

                    return _HoverCategoryTile(
                      name: cat['name'] as String,
                      icon: cat['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () => _onCategorySelected(cat['key'] as String),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),

        // ডান পাশের ফর্ম ও ফলাফল
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputFormCard(availablePresets),
                const SizedBox(height: 20),
                const Text(
                  'নির্বাচিত উপকরণের তালিকা:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildAppliancesList(),
                const SizedBox(height: 20),
                _buildSummaryCard(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// স্মার্টফোন লেআউট (ছোট স্ক্রিনের জন্য পুরোপুরি অপ্টিমাইজড)
  Widget _buildMobileLayout(List<PresetItem> availablePresets) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'যন্ত্রের ধরন বেছে নিন:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppliancePresets.categories.map((cat) {
                final isSelected = cat['key'] == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    avatar: Icon(cat['icon'] as IconData, size: 16, color: isSelected ? Colors.white : Colors.amber.shade900),
                    label: Text(cat['name'] as String),
                    selected: isSelected,
                    selectedColor: Colors.amber.shade700,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) _onCategorySelected(cat['key'] as String);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          _buildInputFormCard(availablePresets),
          const SizedBox(height: 18),
          const Text(
            'নির্বাচিত উপকরণের তালিকা:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          _buildAppliancesList(),
          const SizedBox(height: 16),
          _buildSummaryCard(),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  /// ইনপুট ফর্ম
  Widget _buildInputFormCard(List<PresetItem> availablePresets) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<PresetItem>(
              value: availablePresets.contains(_selectedPreset)
                  ? _selectedPreset
                  : (availablePresets.isNotEmpty ? availablePresets.first : null),
              decoration: const InputDecoration(
                labelText: 'নির্দিষ্ট মডেল/টাইপ নির্বাচন করুন',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: availablePresets.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Text(item.nameBn),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) _applyPreset(val);
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'যন্ত্রের নাম',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _wattController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ওয়াট (W)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('উৎস: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ChoiceChip(
                      label: const Text('এসি (AC)'),
                      selected: _isAc,
                      selectedColor: Colors.blue.shade100,
                      onSelected: (val) => setState(() => _isAc = true),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('ডিসি (DC)'),
                      selected: !_isAc,
                      selectedColor: Colors.green.shade100,
                      onSelected: (val) => setState(() => _isAc = false),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            Wrap(
              spacing: 20,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('পরিমাণ: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('দৈনিক ব্যবহার: ${_usageHours.toStringAsFixed(1)} ঘণ্টা', style: const TextStyle(fontSize: 12)),
                      Slider(
                        value: _usageHours,
                        min: 0.25,
                        max: 24.0,
                        divisions: 95,
                        activeColor: Colors.amber.shade700,
                        onChanged: (val) => setState(() => _usageHours = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _addAppliance,
                icon: const Icon(Icons.add_rounded),
                label: const Text('তালিকায় যুক্ত করুন', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// তালিকা উইজেট
  Widget _buildAppliancesList() {
    if (_appliances.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text(
            'এখনো কোনো সরঞ্জাম যোগ করা হয়নি। ফ্যান, লাইট সিলেক্ট করে যুক্ত করুন।',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: _appliances.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.isAc ? Colors.blue.shade50 : Colors.green.shade50,
              child: Text(
                item.isAc ? 'AC' : 'DC',
                style: TextStyle(
                  color: item.isAc ? Colors.blue.shade800 : Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${item.watt.toInt()}W × ${item.quantity}টি | ${item.usageHours} ঘণ্টা = ${(item.dailyEnergyWh).toStringAsFixed(0)} Wh',
              style: const TextStyle(fontSize: 13),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() {
                  _appliances.removeWhere((it) => it.id == item.id);
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  /// সামারি কার্ড
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFC5E2F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('এসি উপকরণের শক্তি:', style: TextStyle(fontSize: 14)),
              Text('${_totalAcWh.toStringAsFixed(0)} Wh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ডিসি উপকরণের শক্তি:', style: TextStyle(fontSize: 14)),
              Text('${_totalDcWh.toStringAsFixed(0)} Wh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const Divider(color: Colors.blueGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('সর্বমোট দৈনিক চাহিদা:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('${_totalWh.toStringAsFixed(0)} Wh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue.shade900)),
            ],
          ),
        ],
      ),
    );
  }

  /// নিচের স্টিকি বাটন
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2))],
      ),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: _appliances.isEmpty
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SystemParameterScreen(appliances: _appliances),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F4E79),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('পরের ধাপ (System Parameters) ➔', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

/// সাইডবারের হোভার ক্যাটাগরি আইটেম উইজেট
class _HoverCategoryTile extends StatefulWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoverCategoryTile({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_HoverCategoryTile> createState() => _HoverCategoryTileState();
}

class _HoverCategoryTileState extends State<_HoverCategoryTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color contentColor = Colors.black87;

    if (widget.isSelected) {
      bgColor = Colors.amber.shade700;
      contentColor = Colors.white;
    } else if (_isHovered) {
      bgColor = Colors.amber.shade100.withOpacity(0.5);
      contentColor = Colors.amber.shade900;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: contentColor),
              const SizedBox(width: 10),
              Text(
                widget.name,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (widget.isSelected)
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}