import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../screens/detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final list = app.filtered;
    final center = list.isNotEmpty
        ? LatLng(list.first.lat, list.first.lng)
        : const LatLng(35.6892, 51.3890);
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: list.isNotEmpty ? 11 : 6,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.amlak_app',
        ),
        MarkerLayer(
          markers: [
            for (final p in list)
              Marker(
                point: LatLng(p.lat, p.lng),
                width: 44,
                height: 44,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => ListTile(
                        title: Text(p.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${p.city} ـ ${p.address}',
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(propertyId: p.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.location_pin,
                      size: 40, color: Colors.red),
                ),
              ),
          ],
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
            ),
            child: Text('${list.length} ملک روی نقشه',
                style: const TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
