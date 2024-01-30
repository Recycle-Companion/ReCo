import 'package:flutter/material.dart';
import 'package:reco/view/map_page.dart';
import 'package:reco/view/scan_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const MapPage(), ScanPage()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Solution App",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: const Text("Recycle App"),
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => (currentIndex = index)),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
          ],
        ),
      ),
    );
  }
}
