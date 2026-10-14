import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<AppState>().favoriteItems;
    if (favs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('هنوز ملکی را ذخیره نکرده‌اید'),
            Text('روی قلب هر آگهی بزنید', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: favs.length,
      itemBuilder: (_, i) => PropertyCard(property: favs[i]),
    );
  }
}
