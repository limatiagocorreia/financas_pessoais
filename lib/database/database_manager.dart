import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'financas.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(_cards);
    await db.execute(_categorias);
    await db.execute(_transacoes);
    await db.insert('categorias', {
      'categoriaDescricao': 'Alimentação',
      'categoriaCor': 'pink',
      'categoriaIcone': 'restaurant',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Casa',
      'categoriaCor': 'deepPurple',
      'categoriaIcone': 'home',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Educação',
      'categoriaCor': 'indigo',
      'categoriaIcone': 'school',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Mercado',
      'categoriaCor': 'pink',
      'categoriaIcone': 'shopping_cart',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Cuidados Pessoais',
      'categoriaCor': 'amber',
      'categoriaIcone': 'self_improvement',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Assinatura e Serviços',
      'categoriaCor': 'lightBlue',
      'categoriaIcone': 'live_tv',
      'categoriaTipoTransacao': 0
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Salário',
      'categoriaCor': 'green',
      'categoriaIcone': 'money',
      'categoriaTipoTransacao': 1
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Empréstimo',
      'categoriaCor': 'lightGreen',
      'categoriaIcone': 'account_balance',
      'categoriaTipoTransacao': 1
    });
    await db.insert('categorias', {
      'categoriaDescricao': 'Outras Receitas',
      'categoriaCor': 'green',
      'categoriaIcone': 'money',
      'categoriaTipoTransacao': 1
    });

    await db.insert('cards', {
      'cardNumber': '0000 0000 0000 0000',
      'cvv': '123',
      'ownerName': 'FULADO DA SILVA',
      'expireDate': '27/30'
    });
    await db.insert('cards', {
      'cardNumber': '0000 0000 0000 0000',
      'cvv': '312',
      'ownerName': 'FULANO LIMA',
      'expireDate': '21/29'
    });
  }

  String get _categorias => '''
    CREATE TABLE IF NOT EXISTS categorias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoriaDescricao TEXT,
      categoriaCor TEXT,
      categoriaIcone TEXT, 
      categoriaTipoTransacao INTEGER
    );
  ''';

  String get _transacoes => '''
    CREATE TABLE IF NOT EXISTS transacoes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      descricao TEXT,
      tipoTransacao INTEGER,
      valor REAL,
      data INTEGER,
      observacao TEXT, 
      categoriaId INTEGER,
      FOREIGN KEY(categoriaId) REFERENCES categorias(id)
    );
  ''';

  String get _cards => '''
    CREATE TABLE IF NOT EXISTS cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cardNumber TEXT,
      ownerName TEXT,
      cvv TEXT,
      expireDate TEXT
    );
  ''';
}
