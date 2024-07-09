import 'package:flutter/material.dart';
import 'package:kelompok_7/models/sales.dart';
import 'package:kelompok_7/pages/detail/detail_sales.dart';
import 'package:kelompok_7/pages/tambah/tambah_sales_page.dart';
import 'package:kelompok_7/services/api_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  ApiService apiService = ApiService();
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
                  MaterialPageRoute(builder: (context) => TambahSalesPage()),
                );
              },
              child: Text('Tambah Sales'),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await apiService.getSaless();
                setState(() {});
              },
              child: FutureBuilder<List<Sales>>(
                future: apiService.getSaless(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users found'));
                  } else {
                    List<Sales> users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index].buyer),
                          subtitle: Text(users[index].status),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailSalesPage(id: users[index].id),
                              ),
                            ).then((_) async {
                              await apiService.getSaless();
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
