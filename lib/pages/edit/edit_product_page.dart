import 'package:flutter/material.dart';
import 'package:kelompok_7/models/product.dart';
import 'package:kelompok_7/services/api_service.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  const EditProductPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ApiService apiService = ApiService();
  Product? product;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productAttrController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productWeightController = TextEditingController();

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
        _productNameController.text = product!.name;
        _productPriceController.text = product!.price.toString();
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
        title: Text('Edit Product'),
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
                        controller: _productPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Product Price',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Product Price';
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
                              var response = await ApiService().editProduct(
                                  _productNameController.text,
                                  int.parse(_productPriceController.text),
                                  int.parse(_productQtyController.text),
                                  _productAttrController.text,
                                  int.parse(_productWeightController.text),
                                  widget.id);
                              print(
                                  'Product created successfully: ${response.statusCode}');
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Success'),
                                    content:
                                        Text('Product created successfully'),
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
                              print('Error creating Product: $e');
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Failed'),
                                    content: Text('Product creation failed'),
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
