import 'package:financas_pessoais/database/database_manager.dart';
import 'package:financas_pessoais/models/card.dart';

class CardRepository {
  Future<List<CardEntity>> listCards() async {
    final db = await DatabaseManager().getDatabase();

    final List<Map<String, dynamic>> rows = await db.query('cards');

    return rows
        .map((row) => CardEntity(
              id: row['id'],
              cardNumber: row['cardNumber'],
              cvv: row['cvv'],
              expireDate: row['expireDate'],
              ownerName: row['ownerName'],
            ))
        .toList();
  }

  Future<void> insertCard(CardEntity card) async {
    final db = await DatabaseManager().getDatabase();

    db.insert(
      "cards",
      {
        'id': card.id,
        'cardNumber': card.cardNumber,
        'cvv': card.cvv,
        'ownerName': card.ownerName,
        'expireDate': card.expireDate
      },
    );
  }

  Future<int> updateCard(CardEntity card) async {
    final db = await DatabaseManager().getDatabase();

    return db.update(
      'cards',
      {
        'id': card.id,
        'cardNumber': card.cardNumber,
        'cvv': card.cvv,
        'ownerName': card.ownerName,
        'expireDate': card.expireDate
      },
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> removeCard(int id) async {
    final db = await DatabaseManager().getDatabase();
    await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
}
