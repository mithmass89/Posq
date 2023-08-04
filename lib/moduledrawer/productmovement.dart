import 'package:flutter/material.dart';

class ProductMovement extends StatefulWidget {
  const ProductMovement({Key? key}) : super(key: key);

  @override
  State<ProductMovement> createState() => _ProductMovementState();
}

class _ProductMovementState extends State<ProductMovement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pergerakan Barang'),
      ),
      body: Container(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
