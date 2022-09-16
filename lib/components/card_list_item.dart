import 'package:flutter/material.dart';
import '../models/card.dart';
import 'dart:math' as math;

class CardListItem extends StatelessWidget {
  final CardEntity card;

  const CardListItem({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: const EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(card.cardNumber),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(card.expireDate),
                  const SizedBox(width: 28),
                  Text(card.cvv),
                ],
              ),
              const SizedBox(height: 12),
              Text(card.ownerName),
            ],
          ),
        ),
      ),
    );
  }
}
