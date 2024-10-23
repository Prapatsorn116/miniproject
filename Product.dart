import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // สำหรับใช้ rootBundle เพื่อโหลด assets
import 'dart:convert'; // สำหรับถอดรหัส JSON

// หน้ารายละเอียดของสินค้า
class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product; // รับข้อมูลสินค้าที่ถูกเลือก

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.yellow[200],
        foregroundColor: Color(0xffba0000),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['imageUrl'],
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 25,
                color: Color(0xff910000),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'รหัสสินค้า: ${product['productcode'] ?? "ไม่มีข้อมูล"}',
              style: TextStyle(fontSize: 20, color: Color(0xffd35100)),
            ),
            SizedBox(height: 10),
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'เหลือในสต็อก: ${product['stock']} ชิ้น',
              style: TextStyle(fontSize: 20, color: Color(0xff9c00cb)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  // ฟังก์ชันสำหรับโหลดข้อมูลสต็อกจากไฟล์ JSON ภายในแอป
  Future<List<Map<String, dynamic>>> _loadStockData() async {
    final String response = await rootBundle.loadString('assets/stock.json');
    return List<Map<String, dynamic>>.from(json.decode(response));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สินค้าที่ยังเหลืออยู่ในสต็อก'),
        backgroundColor: Colors.yellow[200], // กำหนดสีพื้นหลังของ AppBar
        foregroundColor: Color(0xff5b0000),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadStockData(),
        builder: (context, snapshot) {
          // ขณะกำลังโหลดข้อมูล
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // เมื่อเกิดข้อผิดพลาด
          else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          }
          // กรณีไม่มีข้อมูลหรือข้อมูลว่าง
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีสินค้าที่เหลือในสต็อก'));
          }
          // เมื่อโหลดข้อมูลสำเร็จ
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  // เมื่อผู้ใช้กดสินค้านั้นๆ ให้ไปยังหน้ารายละเอียดสินค้า
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          product['imageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff8400b3),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('รหัสสินค้า ${product['productcode']} '),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Stock Products',
    home: ProductPage(),
  ));
}
