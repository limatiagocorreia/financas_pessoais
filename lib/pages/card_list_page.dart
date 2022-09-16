import 'package:financas_pessoais/components/card_list_item.dart';
import 'package:financas_pessoais/models/card.dart';
import 'package:financas_pessoais/pages/card_create_page.dart';
import 'package:financas_pessoais/repository/card_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({Key? key}) : super(key: key);

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  final _cardRepository = CardRepository();
  late Future<List<CardEntity>> _futureCards;

  @override
  void initState() {
    loadCards();
    super.initState();
  }

  void loadCards() {
    _futureCards = _cardRepository.listCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões')),
      body: FutureBuilder<List<CardEntity>>(
        future: _futureCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final cards = snapshot.data ?? [];
            return ListView.separated(
              itemCount: cards.length,
              itemBuilder: ((context, index) {
                final card = cards[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await _cardRepository.removeCard(card.id!);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Cartão removido com sucesso')));

                          setState(() {
                            cards.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          var success = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => CreateCardPage(
                                editableCard: card,
                              ),
                            ),
                          ) as bool?;

                          if (success != null && success) {
                            setState(() {
                              loadCards();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                    ],
                  ),
                  child: CardListItem(card: card),
                );
              }),
              separatorBuilder: (context, index) => const Spacer(),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? card =
                await Navigator.of(context).pushNamed('/card-insert') as bool?;

            if (card != null && card) {
              setState(() {
                loadCards();
              });
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
