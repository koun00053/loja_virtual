import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;
import 'package:dagugi_acessorios/src/models/item_model.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/quantity_widget.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    required this.item,
  });

  final ItemModel item;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilsServices utilsServices = UtilsServices();

  int cartItemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          //CONTEÚDO
          Column(
            children: [
              Expanded(
                child: Hero(
                  tag: widget.item.imgUrl,
                  child: Image.asset(widget.item.imgUrl),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                        50,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //NOME
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.itemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis, // ...
                              style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Garamond'),
                            ),
                          ),
                          //QuantityWidget(),
                        ],
                      ),
                      //PREÇO
                      Text(
                        utilsServices.priceToCurrency(
                          widget.item.price,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //DESCRIÇÃO
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Text(
                              widget.item.description,
                              style: const TextStyle(
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Garamond',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // BOTÃO E QUANTIDADE
                      Row(
                        children: [
                          // QUANTIDADE
                          Container(
                            margin: const EdgeInsets.only(
                                right: 10), // Espaçamento entre os widgets
                            child: QuantityWidget(
                                suffixText: widget.item.unit,
                                value: cartItemQuantity,
                                result: (quantity) {
                                  setState(() {
                                    cartItemQuantity = quantity;
                                  });
                                }),
                          ),
                          // BOTÃO
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  appData.cartItems.add(appData.itemToCartItem(widget.item, cartItemQuantity));
                                  Navigator.pop(context, "update data");
                                },
                                label: const Text(
                                  'Adicionar Ao Carrinho',
                                  style: TextStyle(
                                    fontFamily: 'Garamond',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.shopping_cart_checkout_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
