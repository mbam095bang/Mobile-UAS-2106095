import 'package:flutter/material.dart';
import 'package:kelompok_7/models/stock.dart';
import 'package:kelompok_7/pages/edit/EDIT_stock_page.dart';
import 'package:kelompok_7/services/api_service.dart';
import 'package:intl/intl.dart';

class DetailStockPage extends StatefulWidget {
  final String id;

  DetailStockPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailStockPage> createState() => _DetailStockPageState();
}

class _DetailStockPageState extends State<DetailStockPage> {
  final ApiService apiService = ApiService();
  Stock? stock;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStock(); // Panggil fungsi untuk mengambil data produk saat pertama kali halaman dimuat
  }

  Future<void> _fetchStock() async {
    try {
      Stock fetchedStock = await apiService.getStock(widget.id);
      print('fetchedStock: $fetchedStock');
      setState(() {
        stock = fetchedStock;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshStock() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _fetchStock(); // Refresh the product data
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Detail Stock'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditStockPage(id: widget.id)),
                            ).then((_) {
                              _refreshStock();
                            });
                          },
                          child: Text('Edit Stock'),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            // alert
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('Hapus stock'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus stock ini?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                            child: Text('Hapus'),
                                            onPressed: () async {
                                              ApiService().delStock(widget.id);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            })
                                      ]);
                                });
                          },
                          child: Text('Hapus Stock'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.id}'),
                        SizedBox(height: 16.0),
                        if (stock != null) ...[
                          Text('Name: ${stock!.name}'),
                          SizedBox(height: 8.0),
                          Text(
                              'Quantity: ${stock!.qty.toString()} ${stock!.attr}'),
                          SizedBox(height: 8.0),
                          Text('Weight: ${stock!.weight.toString()}'),
                          SizedBox(height: 8.0),
                          Text('Create At: ${formatDate(stock!.createdAt)}'),
                          SizedBox(height: 8.0),
                          Text('Update At: ${formatDate(stock!.updatedAt)}'),
                          // Tambahkan detail produk lainnya di sini
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
