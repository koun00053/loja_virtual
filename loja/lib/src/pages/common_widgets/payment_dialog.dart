import 'package:dagugi_acessorios/src/models/order_model.dart';
import 'package:dagugi_acessorios/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  PaymentDialog({super.key, required this.order});

  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //Conteúdo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Título
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: const Text(
                      'Pagamento com Pix',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  //QR Code
                  QrImageView(
                    data: 'sd6f84ds65fdsjhnk5',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  //Venciento
                  Text(
                    'Vencimento: ${utilsServices.fomatDateTime(order.overdueDateTime)}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  //Total
                  Text('Total: ${utilsServices.priceToCurrency(order.total)}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  //Botão de Copia e Cola
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {},
                    label: const Text(
                      'Copiar código Pix',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                    icon: const Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),

            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ))
          ],
        ));
  }
}
