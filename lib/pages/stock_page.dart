import 'package:flutter/material.dart';
import 'package:kelompok_7/models/stock.dart';
import 'package:kelompok_7/pages/detail/detail_stock.dart';
import 'package:kelompok_7/pages/tambah/tambah_stock_page.dart';
import 'package:kelompok_7/services/api_service.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TambahStockPage()),
                );
              },
              child: Text('Tambah Stock'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await apiService.getStocks();
                setState(() {});
              },
              child: FutureBuilder<List<Stock>>(
                future: apiService.getStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users found'));
                  } else {
                    List<Stock> users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index].name),
                          subtitle: Text(
                              '${users[index].qty.toString()} ${users[index].attr}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailStockPage(id: users[index].id),
                              ),
                            ).then((_) async {
                              await apiService.getStocks();
                              setState(() {});
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
