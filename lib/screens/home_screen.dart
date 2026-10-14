import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/sample_data.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_sheet.dart';
import '../utils/format.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (_searchCtrl.text != app.searchQuery) {
      _searchCtrl.value = TextEditingValue(
        text: app.searchQuery,
        selection: TextSelection.collapsed(offset: app.searchQuery.length),
      );
    }
    final list = app.filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: _searchCtrl,
            onChanged: app.setSearch,
            decoration: InputDecoration(
              hintText: 'جستجو: نام، شهر، آدرس...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: app.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => app.setSearch(''),
                    )
                  : IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        builder: (_) => const FilterSheet(),
                      ),
                    ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final c in allCities)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: app.selectedCity == c,
                    onSelected: (_) => app.setCity(c),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ActionChip(
                  avatar: const Icon(Icons.tune, size: 16),
                  label: const Text('فیلتر'),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    builder: (_) => const FilterSheet(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Text('${toFaDigits(list.length.toString())} آگهی پیدا شد',
                  style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              if (app.selectedDeal != null ||
                  app.selectedType != null ||
                  app.minArea != null ||
                  app.maxPrice != null)
                TextButton(
                  onPressed: app.clearFilters,
                  child: const Text('حذف فیلترها'),
                ),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('ملکی پیدا نشد'),
                      TextButton(
                        onPressed: app.clearFilters,
                        child: const Text('حذف فیلترها'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => PropertyCard(property: list[i]),
                ),
        ),
      ],
    );
  }
}
