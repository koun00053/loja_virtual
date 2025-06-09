import 'package:dagugi_acessorios/src/models/cart_item_model.dart';
import 'package:dagugi_acessorios/src/pages/cart/cart_tab.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/quantity_widget.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';

class CartTile extends StatefulWidget {
  final State<CartTab> parentWidget;
  final CartItemModel cartItem;
  final Function(CartItemModel) remove;

  const CartTile({super.key, 
    required this.parentWidget,
    required this.cartItem,
    required this.remove,
  });

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        //IMAGEM
        leading: Image.asset(
          widget.cartItem.item.imgUrl,
          height: 60,
          width: 60,
        ),
        //TITULO
        title: Text(
          widget.cartItem.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Garamond',
          ),
        ),
        //TOTAL
        subtitle: Text(
          utilsServices.priceToCurrency(widget.cartItem.totalPrice()),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        //QUANTIDADE
        trailing: QuantityWidget(
          suffixText: widget.cartItem.item.unit,
          value: widget.cartItem.quantity,
          result: (quantity) {
            setState(() {
              widget.cartItem.quantity = quantity;

              if (quantity == 0) {
                //REMOVER ITEM CARRINHO
                widget.remove(widget.cartItem);
              }

              widget.parentWidget.setState((){});
            });
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
