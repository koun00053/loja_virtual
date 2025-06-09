import 'package:dagugi_acessorios/src/models/item_model.dart';
import 'package:dagugi_acessorios/src/pages/product/product_screen.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;

class ItemTile extends StatefulWidget {
  final ItemModel item;
  final void Function(GlobalKey, ItemModel) cartAnimationMethod;
  final void Function() needToUpdate;

  const ItemTile({
    super.key,
    required this.item,
    required this.cartAnimationMethod,
    required this.needToUpdate
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final UtilsServices utilsServices = UtilsServices();

  final GlobalKey imageGk = GlobalKey();

  IconData getIcon()
  {
    bool isInCart = appData.isExsitInCart(widget.item.itemName);
    return isInCart ? Icons.check: Icons.add_shopping_cart_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          // GestureDetector
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async{
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(item: widget.item),
                ),
              );

              if (result != null)
              {
                widget.needToUpdate();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagem do produto com GlobalKey
                  Expanded(
                    child: Image.asset(
                      widget.item.imgUrl,
                      key: imageGk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Garamond',
                    ),
                  ),
                  Text(
                    utilsServices.priceToCurrency(widget.item.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Garamond',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Ícone do carrinho no canto superior direito
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.cartAnimationMethod(imageGk, widget.item); // Chama a animação
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  getIcon(),
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
