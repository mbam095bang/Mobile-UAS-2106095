import 'package:flutter/material.dart';
import 'package:kelompok_7/models/stock.dart';
import 'package:kelompok_7/services/api_service.dart';

class EditStockPage extends StatefulWidget {
  final String id;
  const EditStockPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final ApiService apiService = ApiService();
  Stock? product;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productAttrController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStock(); // Panggil fungsi untuk mengambil data produk saat pertama kali halaman dimuat
  }

  Future<void> _fetchStock() async {
    try {
      Stock fetchedSales = await apiService.getStock(widget.id);
      print('fetchedSales: $fetchedSales');
      setState(() {
        product = fetchedSales;
        _productNameController.text = product!.name;
        _productAttrController.text = product!.attr;
        _productQtyController.text = product!.qty.toString();
        _productWeightController.text = product!.weight.toString();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Edit Stock'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productNameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _productWeightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Product Weight',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Product Weight';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _productQtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Product Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Product Quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _productAttrController,
                        decoration: InputDecoration(
                          labelText: 'Product Atribute',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Product Atribute';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              var response = await ApiService().editStock(
                                  _productNameController.text,
                                  int.parse(_productQtyController.text),
                                  _productAttrController.text,
                                  int.parse(_productWeightController.text),
                                  widget.id);
                              print(
                                  'Stock created successfully: ${response.statusCode}');
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content: Text('Stock created successfully'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              print('Error creating stock: $e');
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Failed'),
                                    content: Text('Stock creation failed'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text('Kirim'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
