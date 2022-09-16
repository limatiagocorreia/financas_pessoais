import 'package:financas_pessoais/models/card.dart';
import 'package:financas_pessoais/repository/card_repository.dart';
import 'package:financas_pessoais/util/card_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateCardPage extends StatefulWidget {
  CardEntity? editableCard;
  CreateCardPage({
    Key? key,
    this.editableCard,
  }) : super(key: key);

  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  final _cardRepository = CardRepository();

  final _cardNumberController = TextEditingController();
  final _cardExpireDateController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _cardOwnerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final card = widget.editableCard;
    if (card != null) {
      _cardCvvController.text = card.cvv;
      _cardExpireDateController.text = card.expireDate;
      _cardNumberController.text = card.cardNumber;
      _cardOwnerNameController.text = card.ownerName;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cartão'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildCardNumber(),
                const SizedBox(height: 20),
                _buildCardExpireDate(),
                const SizedBox(height: 20),
                _buildCvv(),
                const SizedBox(height: 20),
                _buildOwnerName(),
                const SizedBox(height: 20),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildCardNumber() {
    return TextFormField(
      controller: _cardNumberController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(19),
        FilteringTextInputFormatter.digitsOnly,
        CardNumberFormatter(),
      ],
      decoration: const InputDecoration(
          hintText: '0000 0000 0000 0000',
          labelText: 'Número do cartão',
          border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o número do cartão';
        }
        if (value.length < 19) {
          return 'Número infromado é inválido';
        }

        return null;
      },
    );
  }

  TextFormField _buildOwnerName() {
    return TextFormField(
      controller: _cardOwnerNameController,
      decoration: const InputDecoration(
          hintText: 'Fulano da Silva',
          labelText: 'Nome do titular',
          border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o Nome do titular';
        }
        if (value.length < 5) {
          return 'Nome muito curto';
        }

        return null;
      },
    );
  }

  TextFormField _buildCardExpireDate() {
    return TextFormField(
      controller: _cardExpireDateController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
      ],
      decoration: const InputDecoration(
          hintText: 'mm/yy',
          labelText: 'Data de validade',
          border: OutlineInputBorder()),
      validator: (value) {
        var allowedChars = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '/'
        ];
        var hasInvalidChar = false;
        value!.characters.forEach((element) {
          if (!allowedChars.contains(element.toString())) {
            hasInvalidChar = true;
          } else {
            hasInvalidChar = false;
          }
        });
        if (hasInvalidChar) {
          return 'Data possui caracter inválido';
        }
        if (value == null || value.isEmpty) {
          return 'Informe a data de validade';
        }
        if (value.length < 5 || value[2] != '/') {
          return 'Data informada é inválida - formato ';
        }

        return null;
      },
    );
  }

  TextFormField _buildCvv() {
    return TextFormField(
      controller: _cardCvvController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: const InputDecoration(
          hintText: '000', labelText: 'CVV', border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o cvv do cartão';
        }

        if (value.length < 3) {
          return 'cvv inválido';
        }

        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Cadastrar'),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final cardNumber = _cardNumberController.text;
            final cvv = _cardCvvController.text;
            final ownerName = _cardOwnerNameController.text;
            final expireDate = _cardExpireDateController.text;

            final card = CardEntity(
              cardNumber: cardNumber,
              cvv: cvv,
              expireDate: expireDate,
              ownerName: ownerName,
            );

            try {
              if (widget.editableCard != null) {
                card.id = widget.editableCard!.id;
                await _cardRepository.updateCard(card);
              } else {
                await _cardRepository.insertCard(card);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('cartao cadastrado com sucesso'),
              ));

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
      ),
    );
  }
}
