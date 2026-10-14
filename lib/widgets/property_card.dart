import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../screens/detail_screen.dart';

Widget propertyImage(String url, {double? height, BoxFit fit = BoxFit.cover}) {
  if (url.startsWith('/') || url.startsWith('file:')) {
    final path = url.startsWith('file:') ? Uri.parse(url).path : url;
    final f = File(path);
    if (f.existsSync()) {
      return Image.file(f, height: height, width: double.infinity, fit: fit);
    }
  }
  return Image.network(
    url,
    height: height,
    width: double.infinity,
    fit: fit,
    errorBuilder: (_, __, ___) => Container(
      height: height ?? 180,
      color: Colors.grey.shade200,
      child: const Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
    ),
    loadingBuilder: (c, w, p) {
      if (p == null) return w;
      return Container(
        height: height ?? 180,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    },
  );
}

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final fav = app.isFav(property.id);
    final img = property.images.isNotEmpty ? property.images.first : '';
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(propertyId: property.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: img.isEmpty
                      ? Container(
                          height: 180,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.home, size: 64),
                        )
                      : propertyImage(img, height: 180),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: property.deal == DealType.sale
                          ? Colors.green.shade700
                          : Colors.orange.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dealLabel(property.deal),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: InkWell(
                    onTap: () => app.toggleFav(property.id),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (property.isUserAdded)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'آگهی من',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      Expanded(
                        child: Text(
                          '${property.city} ـ ${property.address}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip(Icons.square_foot,
                          formatAreaFa(property.area)),
                      _chip(Icons.bed_outlined,
                          '${toFaDigits(property.rooms.toString())} خوابه'),
                      _chip(Icons.category_outlined,
                          propertyTypeLabel(property.type)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatPriceFa(property.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
