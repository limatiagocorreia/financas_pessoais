class CardEntity {
  int? id;
  String cardNumber;
  String ownerName;
  String cvv;
  String expireDate;

  CardEntity({
    this.id,
    required this.cardNumber,
    required this.cvv,
    required this.expireDate,
    required this.ownerName,
  });
}
