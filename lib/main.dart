import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/add_screen.dart';
import 'screens/favorites_screen.dart';
import 'utils/format.dart';

void main() {
  runApp(const AmlakApp());
}

class AmlakApp extends StatelessWidget {
  const AmlakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: MaterialApp(
        title: 'املاک',
        debugShowCheckedModeBanner: false,
        locale: const Locale('fa', 'IR'),
        supportedLocales: const [Locale('fa', 'IR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1565C0),
          fontFamily: null,
        ),
        home: const MainShell(),
        routes: {
          '/map': (_) => Scaffold(
                appBar: AppBar(title: const Text('نقشه')),
                body: const MapScreen(),
              )
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final favCount = app.favorites.length;
    final pages = [
      const HomeScreen(),
      const MapScreen(),
      AddScreen(onSaved: () => setState(() => index = 0)),
      const FavoritesScreen(),
    ];
    final titles = ['املاک', 'نقشه', 'ثبت آگهی', 'علاقه‌مندی‌ها'];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[index]),
          centerTitle: true,
          actions: [
            if (index == 0)
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'حذف فیلترها',
                onPressed: app.clearFilters,
              ),
          ],
        ),
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'خانه'),
            const NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'نقشه'),
            const NavigationDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: 'ثبت آگهی'),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: favCount > 0,
                label: Text(toFaDigits(favCount.toString())),
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: Badge(
                isLabelVisible: favCount > 0,
                label: Text(toFaDigits(favCount.toString())),
                child: const Icon(Icons.favorite),
              ),
              label: 'علاقه‌مندی‌ها',
            ),
          ],
        ),
      ),
    );
  }
}
