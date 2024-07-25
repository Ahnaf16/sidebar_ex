import 'package:flutter/material.dart';
import 'package:sidebar_ex/sidebar_ex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData(bool isDark) {
      return ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
        brightness: isDark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeData(true),
      darkTheme: themeData(false),
      themeMode: ThemeMode.light,
      home: const NavRootView(),
    );
  }
}

class NavRootView extends StatefulWidget {
  const NavRootView({super.key});

  @override
  State<NavRootView> createState() => _NavRootViewState();
}

class _NavRootViewState extends State<NavRootView> {
  List<Destination> destinations() => [
        const Destination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        const GroupedDestination(
          icon: Icon(Icons.add),
          label: Text('Products'),
          children: [
            Destination(
              icon: Icon(Icons.list),
              label: Text('List all'),
            ),
            Destination(
              icon: Icon(Icons.add_a_photo),
              label: Text('Add new'),
            ),
          ],
        ),
        const Destination(
          icon: Icon(Icons.receipt),
          label: Text('Order'),
        ),
        const Destination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ];

  bool expand = true;
  int selected = 0;
  int? childSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            expand = !expand;
            setState(() {});
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Row(
        children: [
          SidebarExTheme(
            data: SidebarExThemeData(
                // tileColor: Colors.green,
                ),
            child: SideBarEx(
              extended: expand,
              destinations: destinations(),
              selectedIndex: selected,
              selectedChildIndex: childSelected,
              onDestinationSelected: (rootIndex, childIndex, extra) {
                selected = rootIndex;
                childSelected = childIndex;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Container(
              // margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
