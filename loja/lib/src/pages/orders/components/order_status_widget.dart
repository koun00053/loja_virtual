import 'package:dagugi_acessorios/src/config/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final String status;
  final bool isOverdue;

  final Map<String, int> allStatus = <String, int>{
    'pending_payment': 0,
    'refunded': 1,
    'paid': 2,
    'preparing_purchase': 3,
    'shipping': 4,
    'delivered': 5,
  };

  int get currentStatus => allStatus[status]!;

  OrderStatusWidget({super.key, required this.status, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusDot(
          isActive: true,
          title: 'Pedido Confirmado',
        ),
        const _CustomDivider(),
        if (currentStatus == 1) ...[
          const _StatusDot(
            isActive: true,
            title: 'Pix Estornado',
            backgroundColor: Colors.orange,
          ),
        ] else if (isOverdue) ...[
          const _StatusDot(
            isActive: true,
            title: 'Pagamento Pix Vencido',
            backgroundColor: Colors.red,
          ),
        ] else ...[
          _StatusDot(isActive: currentStatus >= 2, title: 'Pagamento'),
          const _CustomDivider(),
          _StatusDot(isActive: currentStatus >= 3, title: 'Preparando'),
          const _CustomDivider(),
          _StatusDot(isActive: currentStatus >= 4, title: 'Envio'),
          const _CustomDivider(),
          _StatusDot(isActive: currentStatus == 5, title: 'Entregue'),

          /// ...[] adiciona lista(componentes)
        ]
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      height: 10,
      width: 2,
      color: Colors.grey[300],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot(
      {super.key,
      required this.isActive,
      required this.title,
      this.backgroundColor});

  final bool isActive;
  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Dot
        Container(
          alignment: Alignment.center,
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black, //Borda Botão
            ),
            color: isActive
                ? backgroundColor ?? Colors.green
                : Colors.transparent, //Cor do botão ativo
          ),
          child: isActive
              ? const Icon(
                  Icons.check,
                  size: 13,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(width: 5), //Espaçamento entre o dot e o texto

        //Texto
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
