import 'package:dagugi_acessorios/src/models/cart_item_model.dart';
import 'package:dagugi_acessorios/src/models/order_model.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/payment_dialog.dart';
import 'package:dagugi_acessorios/src/pages/orders/components/order_status_widget.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  OrderTile({super.key, required this.order});

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: order.status == 'pending_payment',
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedido: ${order.id}'),
              Text(
                utilsServices.fomatDateTime(order.createdDateTime),
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment:
              CrossAxisAlignment.stretch, //Texto Total na esquerda
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  //Lista de produtos
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 150,
                      child: ListView(
                        children: order.items.map((orderItem) {
                          return _OrderItemWidget(
                              utilsServices: utilsServices,
                              orderItem: orderItem);
                        }).toList(),
                      ),
                    ),
                  ),
                  //Divisão
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                    width: 8,
                  ),
                  //Status do pedido
                  Expanded(
                    flex: 2,
                    child: OrderStatusWidget(
                      status: order.status,
                      isOverdue: order.overdueDateTime.isBefore(
                        DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Total Geral
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: utilsServices.priceToCurrency(order.total),
                  ),
                ],
              ),
            ),
            //Botão Pagamento
            Visibility(
              visible: order.status == 'pending_payment',
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return PaymentDialog(
                        order: order,
                      );
                    },
                  );
                },
                label: const Text('Ver QR Code Pix'),
                icon: Image.asset(
                  'assets/images/pix/pix.png',
                  height: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({
    super.key,
    required this.utilsServices,
    required this.orderItem,
  });

  final UtilsServices utilsServices;
  final CartItemModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(child: Text(orderItem.item.itemName)),
          Text(utilsServices.priceToCurrency(orderItem.totalPrice())),
        ],
      ),
    );
  }
}
