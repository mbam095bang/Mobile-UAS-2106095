import 'package:flutter/material.dart';
import 'package:kelompok_7/models/product.dart';
import 'package:kelompok_7/pages/edit/edit_product_page.dart';
import 'package:kelompok_7/services/api_service.dart';
import 'package:intl/intl.dart';

class DetailProductPage extends StatefulWidget {
  final String id;

  DetailProductPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final ApiService apiService = ApiService();
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct(); // Panggil fungsi untuk mengambil data produk saat pertama kali halaman dimuat
  }

  Future<void> _fetchProduct() async {
    try {
      Product fetchedProduct = await apiService.getProduct(widget.id);
      print('fetchedProduct: $fetchedProduct');
      setState(() {
        product = fetchedProduct;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _fetchProduct(); // Refresh the product data
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
        title: Text('Detail Product'),
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
                                      EditProductPage(id: widget.id)),
                            ).then((_) {
                              _refreshProduct();
                            });
                          },
                          child: Text('Edit Product'),
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
                                      title: Text('Hapus product'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus product ini?'),
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
                                              ApiService()
                                                  .delProduct(widget.id);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            })
                                      ]);
                                });
                          },
                          child: Text('Hapus Product'),
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
                        if (product != null) ...[
                          Text('Name: ${product!.name}'),
                          SizedBox(height: 8.0),
                          Text(
                              'Quantity: ${product!.qty.toString()} ${product!.attr}'),
                          SizedBox(height: 8.0),
                          Text('Weight: ${product!.weight.toString()}'),
                          SizedBox(height: 8.0),
                          Text('Price: ${product!.price.toString()}'),
                          SizedBox(height: 8.0),
                          Text('Create At: ${formatDate(product!.createdAt)}'),
                          SizedBox(height: 8.0),
                          Text('Update At: ${formatDate(product!.updatedAt)}'),
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
