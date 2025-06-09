import 'package:dagugi_acessorios/src/models/cart_item_model.dart';
import 'package:dagugi_acessorios/src/models/order_model.dart';
import 'package:dagugi_acessorios/src/pages/cart/components/cart_tile.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/payment_dialog.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();
  final GlobalKey<_CartTabState> cartTabKey = GlobalKey<_CartTabState>();

  void removeItemFromCart(CartItemModel cartITem) {
    setState(() {
      appData.cartItems.remove(cartITem);
      utilsServices.showToast(
          message: '${cartITem.item.itemName} removido do carrinho');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          'Carrinho',
          style: TextStyle(fontFamily: 'Garamond'),
        ),
      ),
      body: Column(
        children: [
          //LISTA DE ITENS CARRINHO
          Expanded(
            child: ListView.builder(
              itemCount: appData.cartItems.length,
              itemBuilder: (_, index) {
                return CartTile(
                    parentWidget : this,
                    cartItem: appData.cartItems[index],
                    remove: removeItemFromCart);
              },
            ),
          ),
          //TOTAL E BOTÃO DE CONCLUIR O PEDIDO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(fontSize: 14, fontFamily: 'Garamond'),
                ),
                Text(
                  utilsServices.priceToCurrency(appData.cartTotalPrice()),
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? result = await showOrderConfirmation();
                      if (result ?? false) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            OrderModel order = appData.orderFromCart();
                            appData.orders.insert(0, order);
                            return PaymentDialog(order: order);
                          }
                        );
                      } else {
                        utilsServices.showToast(
                            message: 'Pedido não confirmado', isError: true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Concluir pedido',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmação'),
          content: const Text('Deseja realmente concluir o pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
