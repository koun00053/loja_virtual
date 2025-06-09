import 'package:dagugi_acessorios/src/models/cart_item_model.dart';
import 'package:dagugi_acessorios/src/models/item_model.dart';
import 'package:dagugi_acessorios/src/models/order_model.dart';
import 'package:dagugi_acessorios/src/models/user_model.dart';

ItemModel Alianca_Tradicional = ItemModel(
  id : 0,
  description: 'Aliança Tradicional Dourado',
  imgUrl: 'assets/images/products/alianca/alianca_tradicional.png',
  itemName: 'Aliança Tradicional',
  price: 60.00,
  unit: 'un',
  size: '22',
  category: 'Alianças'
);
ItemModel Anel_Prata = ItemModel(
  id : 1,
  description: 'Anel de Prata',
  imgUrl: 'assets/images/products/anel/anel_prata.png',
  itemName: 'Anel De Prata',
  price: 70.00,
  unit: 'un',
  size: '24',
  category: 'Anéis'
);

ItemModel Brinco_Prata = ItemModel(
  id : 2,
  description: 'Brinco de Prata',
  imgUrl: 'assets/images/products/brinco/brinco_prata.png',
  itemName: 'Brinco de Prata',
  price: 35.00,
  unit: 'un',
  size: '22',
  category: 'Brincos'
);
ItemModel Colar_Prata_Feminino = ItemModel(
  id : 3,
  description: 'Colar de Prata Feminino',
  imgUrl: 'assets/images/products/colar/colar_feminino.png',
  itemName: 'Colar de Prata Feiminino',
  price: 45.00,
  unit: 'un',
  size: '20',
  category: 'Colares'
);
ItemModel Colar__Prata_Masculino = ItemModel(
  id : 4,
  description: 'Colar Prata Masculino',
  imgUrl: 'assets/images/products/colar/colar_masculino.png',
  itemName: 'Colar Prata Masculino',
  price: 50.00,
  unit: 'un',
  size: '20',
  category: 'Colares'
);
ItemModel Colar_Dourado = ItemModel(
  id : 5,
  description: 'Colar Dourado',
  imgUrl: 'assets/images/products/colar/colar_dourado.png',
  itemName: 'Colar Dourado',
  price: 15.00,
  unit: 'un',
  size: '26',
  category: 'Colares'
);
ItemModel Pingente_Prata = ItemModel(
  id : 6,
  description: 'Pingente Prata',
  imgUrl: 'assets/images/products/pingente/pingente_prata.png',
  itemName: 'Pingente Prata',
  price: 20.00,
  unit: 'un',
  size: '24',
  category: 'Pingentes'
);
ItemModel Pulseira_Dourada = ItemModel(
  id : 7,
  description: 'Pulseira de Dourada',
  imgUrl: 'assets/images/products/pulseira/pulseira_dourada.png',
  itemName: 'Pulseira Dourada',
  price: 18.00,
  unit: 'un',
  size: '24',
  category: 'Pulseira'
);

List<ItemModel> items = [
  Alianca_Tradicional,
  Anel_Prata,
  Brinco_Prata,
  Colar_Prata_Feminino,
  Colar__Prata_Masculino,
  Colar_Dourado,
  Pingente_Prata,
  Pulseira_Dourada,
];

List<String> categories = [
  'Todos',
  'Anéis',
  'Alianças',
  'Brincos',
  'Colares',
  'Pingentes',
  'Pulseira',
  'Braceletes',
];

List<CartItemModel> cartItems = [
  // CartItemModel(item: Anel_Prata, quantity: 1),
  // CartItemModel(item: Brinco_Prata, quantity: 1),
  // CartItemModel(item: Alianca_Tradicional, quantity: 1),
];

CartItemModel itemToCartItem(ItemModel item, int count)
{
  return CartItemModel(item: item, quantity: count);
}

int getCartItemCount()
{
  int nCount = 0;
  for (int i = 0; i < cartItems.length; i++) {
    nCount += cartItems[i].quantity;
  }
  return nCount;
}

bool isExsitInCart(String itemName)
{
  bool exist = false;
  for (int i = 0; i < cartItems.length; i++) {
    if (itemName == cartItems[i].item.itemName)
    {
      exist = true;
      break;
    }
  }
  return exist;
}

UserModel user = UserModel(
  phone: '99 9 9999-9999',
  cpf: '999.999.999-99',
  email: 'teste@gmail.com',
  name: 'Gustavo',
  password: '',
);

double cartTotalPrice() {
  double total = 0;

  for (var item in cartItems) {
    total += item.totalPrice();
  }
  return total;
}

List<OrderModel> orders = [
  
];

OrderModel orderFromCart()
{
  int nOrderIndex = orders.length + 1;
  DateTime createdDateTime = DateTime.now();
  DateTime overdueDateTime = createdDateTime.add(const Duration(days:1));
  return OrderModel(
    copyAndPaste: 'Pedido $nOrderIndex',
    createdDateTime: createdDateTime,
    overdueDateTime: overdueDateTime,
    items: cartItems,
    status: 'pending_payment',
    total: cartTotalPrice(),
    id: '$nOrderIndex');
}  
