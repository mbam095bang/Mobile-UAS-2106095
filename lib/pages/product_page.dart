import 'package:flutter/material.dart';
import 'package:kelompok_7/models/product.dart';
import 'package:kelompok_7/pages/detail/detail_product.dart';
import 'package:kelompok_7/pages/tambah/tambah_product_page.dart';
import 'package:kelompok_7/services/api_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            // buatkan saya tombol fullwidth
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
                MaterialPageRoute(builder: (context) => TambahProductPage()),
              );
            },
            child: Text('Tambah Product'),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await apiService.getProducts();
              setState(() {});
            },
            child: FutureBuilder<List<Product>>(
              future: apiService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  List<Product> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(users[index].name),
                        subtitle: Text(users[index].price.toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailProductPage(id: users[index].id),
                            ),
                          ).then((_) async {
                            await apiService.getProducts();
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
      ]),
    );
  }
}


// import 'package:flutter/material.dart';

// class ProductPage extends StatefulWidget {
//   const ProductPage({super.key});

//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               // Add your logic here to handle the "Tambah" button press
//               print('Tambah button pressed');
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Text('Product Page', style: TextStyle(color: Colors.black)),
//       ),
//     );
//   }
// }