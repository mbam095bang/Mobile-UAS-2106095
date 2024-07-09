import 'package:flutter/material.dart';
import 'package:kelompok_7/models/product.dart';
import 'package:kelompok_7/models/sales.dart';
import 'package:kelompok_7/models/stock.dart';
import 'package:kelompok_7/services/api_service.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  Future<List<Product>>? _fetchProductsFuture;
  int _totalProducts = 0; // Variable untuk menyimpan total produk
  // ignore: unused_field
  Future<List<Stock>>? _fetchStocksFuture;
  int _totalStocks = 0; // Variable untuk menyimpan total stocks
  // ignore: unused_field
  Future<List<Sales>>? _fetchSalesFuture;
  int _totalSales = 0; // Variable untuk menyimpan total sales

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = _fetchProducts();
    _fetchStocksFuture = _fetchStocks();
    _fetchSalesFuture = _fetchSales();
  }

  Future<List<Product>> _fetchProducts() async {
    List<Product> products = await apiService.getProducts();
    setState(() {
      _totalProducts = products.length; // Mengupdate total produk
    });
    return products;
  }

  Future<List<Stock>> _fetchStocks() async {
    List<Stock> stocks = await apiService.getStocks();
    setState(() {
      _totalStocks = stocks.length; // Mengupdate total stocks
    });
    return stocks;
  }

  Future<List<Sales>> _fetchSales() async {
    List<Sales> sales = await apiService.getSaless();
    setState(() {
      _totalSales = sales.length; // Mengupdate total sales
    });
    return sales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store, size: 100, color: Colors.black),
              SizedBox(height: 10),
              Text(
                'Selamat datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'di Toko Jajanan Garoet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),
              FutureBuilder<List<Product>>(
                future: _fetchProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Menampilkan loading spinner
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Jika data berhasil diambil, tampilkan UI yang sesuai
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('$_totalProducts', 'Products', 1),
                          SizedBox(width: 10),
                          _buildButton('$_totalStocks', 'Stocks', 2),
                          SizedBox(width: 10),
                          _buildButton('$_totalSales', 'Sales', 3),
                        ],
                      ),
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String number, String label, int page) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          widget.pageController.jumpToPage(page);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 100),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Text(number,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
