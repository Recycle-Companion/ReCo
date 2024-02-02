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

  final Color light = const Color(0xfff1f1f1);
  final Color dark = const Color(0xff538f47);
  final Color grey = const Color(0xff373737);


  @override
  Widget build(BuildContext context) {
    final screens = [const MapPage(), ScanPage()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ReCo",
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: true,
      ),

      home: Scaffold(
        appBar: AppBar(
          title: Image.asset("assets/logo.png", height: 26,),
          backgroundColor: light,
          centerTitle: true,
        ),

        body: screens[currentIndex],
        extendBody: true,

        bottomNavigationBar: SafeArea(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: dark,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: dark.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                )
              ]
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.location_on),
                  iconSize: (currentIndex == 0) ? 30 : 25,
                  color: (currentIndex == 0) ? light : grey,
                  onPressed: () => setState(() => currentIndex = 0),
                ),

                IconButton(
                  icon: Icon(Icons.camera),
                  iconSize: (currentIndex == 1) ? 30 : 25,
                  color: (currentIndex == 1) ? light : grey,
                  onPressed: () => setState(() => currentIndex = 1),
                ),
              ],
            ),
          )
        ),

        /*
        BottomNavigationBar(
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
        */
        
      ),
    );
  }
}
