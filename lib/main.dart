import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_7/pages/home_page.dart';
import 'package:kelompok_7/pages/product_page.dart';
import 'package:kelompok_7/pages/sales_page.dart';
import 'package:kelompok_7/pages/stock_page.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.black, // Set the background color of the navigation bar
    systemNavigationBarIconBrightness:
        Brightness.light, // Set the color of the navigation bar icons
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _page = 0;
  final List<String> _pageNameList = ['Home', 'Product', 'Stock', 'Sales'];
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.black,
        backgroundColor: Colors.white,
        key: _bottomNavigationKey,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.local_mall, size: 30, color: Colors.white),
          Icon(Icons.dns, size: 30, color: Colors.white),
          Icon(Icons.accessibility_new, size: 30, color: Colors.white),
        ],
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 1),
              curve: Curves.easeInOut);
        },
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SafeArea(
                  child: SizedBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_pageNameList[_page],
                                style: TextStyle(color: Colors.white))
                          ]),
                      height: 80),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _page = index;
                    });
                    final CurvedNavigationBarState? navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState?.setPage(index);
                  },
                  children: <Widget>[
                    HomePage(pageController: _pageController),
                    ProductPage(),
                    StockPage(),
                    SalesPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
