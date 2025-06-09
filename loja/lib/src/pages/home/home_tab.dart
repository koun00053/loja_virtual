import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:dagugi_acessorios/src/models/item_model.dart';
import 'package:dagugi_acessorios/src/pages/common_widgets/custom_shimmer.dart';
import 'package:dagugi_acessorios/src/pages/home/components/category_tile.dart';
import 'package:dagugi_acessorios/src/pages/home/components/item_tile.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onCartPage});

  final Function() onCartPage;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'Todos';
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  final TextEditingController _searchEditController = TextEditingController();

  String _searchText = '';

  List<ItemModel> _selectedItems = [...appData.items];

  late Function(GlobalKey) runAddToCardAnimation;

  final UtilsServices utilsServices = UtilsServices();
  bool isLoading = true;

  void itemSelectedCartAnimations(GlobalKey gkImage, ItemModel item) {
    setState(() {
      appData.cartItems.add(appData.itemToCartItem(item));  
    });
    runAddToCardAnimation(gkImage);
  }

  void updateSelectedItems()
  {
    if (_searchText.isNotEmpty)
    {
      _selectedItems.clear();
      for (int i = 0; i < appData.items.length; i++)
      {
        if (appData.items[i].itemName.toLowerCase().contains(_searchText.toLowerCase())) {
          _selectedItems.add(appData.items[i]);
        }
      }
    }
    else {
      _selectedItems = [...appData.items];
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 30),
            children: [
              TextSpan(
                text: 'Dagugi',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'GreatVibes',
                ),
              ),
              /*ESPAÇAMENTO DAS PALAVRAS
              TextSpan(
                text: ' ',
                style: TextStyle(fontSize: 30),
              ),
              TextSpan(
                text: 'Acessórios',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Garamond',
                ),
              ),*/
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
            ),
            child: GestureDetector(
              onTap: () {
                widget.onCartPage();
              },
              child: Badge(
                badgeStyle: BadgeStyle(
                  badgeColor: Colors.red,
                ),
                badgeContent: Text(
                  appData.getCartItemCount().toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                child: AddToCartIcon(
                  key: globalKeyCartItems,
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCardAnimation = addToCardAnimationMethod;
        },
        child: Column(
          children: [
            //CAMPO PESQUISA//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: TextFormField(
                controller: _searchEditController,
                onChanged: (text) {
                  setState(() {
                    _searchText = text; // Update the input text on change
                    updateSelectedItems();
                });
              },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  isDense: true,
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 21,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            //CATEGORIAS//
            Container(
              padding: const EdgeInsets.only(left: 25),
              height: 40,
              child: !isLoading
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return CategoryTile(
                          onPressed: () {
                            setState(() {
                              selectedCategory = appData.categories[index];
                            });
                          },
                          category: appData.categories[index],
                          isSelected:
                              appData.categories[index] == selectedCategory,
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(
                            width: 10,
                          ),
                      itemCount: appData.categories.length)
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        10,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          alignment: Alignment.center,
                          child: CustomShimmer(
                            height: 20,
                            width: 80,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
            ),
            //GRID//
            Expanded(
              child: !isLoading
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 9 / 11.5),
                      itemCount: _selectedItems.length,
                      itemBuilder: (_, index) {
                        return ItemTile(
                          item: _selectedItems[index],
                          cartAnimationMethod: itemSelectedCartAnimations,
                        );
                      },
                    )
                  : GridView.count(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 11.5,
                      children: List.generate(
                          10,
                          (index) => CustomShimmer(
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                              )),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
