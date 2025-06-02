import 'package:dagugi_acessorios/src/pages/orders/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          return OrderTile(
            order: appData.orders[index],
          );
        },
        itemCount: appData.orders.length,
      ),
    );
  }
}
