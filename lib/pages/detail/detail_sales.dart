import 'package:flutter/material.dart';
import 'package:kelompok_7/models/sales.dart';
import 'package:kelompok_7/pages/edit/edit_sales_page.dart';
import 'package:kelompok_7/services/api_service.dart';
import 'package:intl/intl.dart';

class DetailSalesPage extends StatefulWidget {
  final String id;

  DetailSalesPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailSalesPage> createState() => _DetailSalesPageState();
}

class _DetailSalesPageState extends State<DetailSalesPage> {
  final ApiService apiService = ApiService();
  Sales? sales;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSales(); // Panggil fungsi untuk mengambil data produk saat pertama kali halaman dimuat
  }

  Future<void> _fetchSales() async {
    try {
      Sales fetchedSales = await apiService.getSales(widget.id);
      print('fetchedSales: $fetchedSales');
      setState(() {
        sales = fetchedSales;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshSales() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _fetchSales(); // Refresh the product data
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
        title: Text('Detail Sales'),
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
                                      EditSalesPage(id: widget.id)),
                            ).then((_) {
                              _refreshSales();
                            });
                          },
                          child: Text('Edit Sales'),
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
                                      title: Text('Hapus Sales'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus sales ini?'),
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
                                              ApiService().delSales(widget.id);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            })
                                      ]);
                                });
                          },
                          child: Text('Hapus Sales'),
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
                        if (sales != null) ...[
                          Text('Buyer: ${sales!.buyer}'),
                          SizedBox(height: 8.0),
                          Text('Phone: ${sales!.phone}'),
                          SizedBox(height: 8.0),
                          Text('Date: ${sales!.date}'),
                          SizedBox(height: 8.0),
                          Text('Status: ${sales!.status}'),
                          SizedBox(height: 8.0),
                          Text('Create At: ${formatDate(sales!.createdAt)}'),
                          SizedBox(height: 8.0),
                          Text('Update At: ${formatDate(sales!.updatedAt)}'),
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
