import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DealType? deal;
  PropertyType? type;
  final minAreaCtrl = TextEditingController();
  final maxPriceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final app = Provider.of<AppState>(context, listen: false);
    deal = app.selectedDeal;
    type = app.selectedType;
    if (app.minArea != null) minAreaCtrl.text = app.minArea.toString();
    if (app.maxPrice != null) maxPriceCtrl.text = app.maxPrice.toString();
  }

  @override
  void dispose() {
    minAreaCtrl.dispose();
    maxPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 16,
        left: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('فیلتر جستجو',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 12),
            const Text('نوع معامله'),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('همه'),
                  selected: deal == null,
                  onSelected: (_) => setState(() => deal = null),
                ),
                ChoiceChip(
                  label: const Text('فروش'),
                  selected: deal == DealType.sale,
                  onSelected: (_) =>
                      setState(() => deal = DealType.sale),
                ),
                ChoiceChip(
                  label: const Text('اجاره'),
                  selected: deal == DealType.rent,
                  onSelected: (_) =>
                      setState(() => deal = DealType.rent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('نوع ملک'),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('همه'),
                  selected: type == null,
                  onSelected: (_) => setState(() => type = null),
                ),
                for (final t in PropertyType.values)
                  ChoiceChip(
                    label: Text(propertyTypeLabel(t)),
                    selected: type == t,
                    onSelected: (_) => setState(() => type = t),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: minAreaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'حداقل متراژ (متر)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: maxPriceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'حداکثر قیمت (تومان)',
                hintText: 'مثلا 5000000000',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('حذف فیلتر'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final minA = int.tryParse(minAreaCtrl.text.trim());
                      final maxP = int.tryParse(maxPriceCtrl.text.trim());
                      Provider.of<AppState>(context, listen: false).setFilters(
                        deal: deal,
                        type: type,
                        minAreaP: minA,
                        maxPriceP: maxP,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('اعمال فیلتر'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
