import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../models/property.dart';
import '../utils/format.dart';
import '../widgets/property_card.dart';

class DetailScreen extends StatelessWidget {
  final String propertyId;
  const DetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = app.byId(propertyId);
    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('جزئیات')),
        body: const Center(child: Text('این آگهی حذف شده است')),
      );
    }
    final fav = app.isFav(p.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                color: fav ? Colors.red : null),
            onPressed: () => app.toggleFav(p.id),
          ),
          if (p.isUserAdded)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('حذف آگهی؟'),
                    content: const Text('این آگهی برای همیشه حذف می‌شود.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('انصراف')),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('حذف')),
                    ],
                  ),
                );
                if (ok == true && context.mounted) {
                  await app.removeProperty(p.id);
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: Text('تماس: ${toFaDigits(p.phone)}'),
                  onPressed: () async {
                    final uri = Uri.parse('tel:${p.phone}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('امکان تماس وجود ندارد')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (p.images.isNotEmpty)
              SizedBox(
                height: 260,
                child: PageView.builder(
                  itemCount: p.images.length,
                  itemBuilder: (_, i) => propertyImage(p.images[i]),
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Icon(Icons.home, size: 80),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: p.deal == DealType.sale
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(dealLabel(p.deal)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(propertyTypeLabel(p.type)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(p.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      Expanded(
                        child: Text('${p.city} ـ ${p.address}',
                            style:
                                const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(formatPriceFa(p.price),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _info(Icons.square_foot, formatAreaFa(p.area)),
                      _info(Icons.bed_outlined,
                          '${toFaDigits(p.rooms.toString())} خوابه'),
                      _info(Icons.location_city_outlined, p.city),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('توضیحات',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(p.description),
                  const SizedBox(height: 16),
                  const Text('موقعیت تقریبی',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                      'عرض جغرافیایی ${toFaDigits(p.lat.toString())} ـ طول جغرافیایی ${toFaDigits(p.lng.toString())}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('نمایش روی نقشه'),
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, '/map'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
