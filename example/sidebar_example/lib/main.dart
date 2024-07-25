import 'package:flutter/material.dart';
import 'package:sidebar_ex/sidebar_ex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavRootView(Scaffold()),
    );
  }
}

class NavRootView extends StatelessWidget {
  const NavRootView(this.child, {super.key});

  final Widget child;

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

  @override
  Widget build(BuildContext context) {
    bool expand = true;
    int selected = 0;
    int? childSelected;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SidebarExTheme(
        data: SidebarExThemeData(
            // tileColor: Colors.green,
            ),
        child: SideBarEx(
          trailing: IconButton(
            onPressed: () {
              expand = !expand;
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          extended: expand,
          destinations: destinations(),
          selectedIndex: selected,
          selectedChildIndex: childSelected,
          onDestinationSelected: (rootIndex, childIndex, extra) {
            selected = rootIndex;
            childSelected = childIndex;
          },
        ),
      ),
    );
  }
}
