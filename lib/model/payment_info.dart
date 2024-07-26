class PaymentInfo{
  final String accountNumber;
  final String subAccountId;
  final String businessName;
  final String accountOwnerName;
  final int accountOwnerId;
  final String bankId;
  final String bankName;

  PaymentInfo({
    required this.accountOwnerId,
    required this.accountNumber,
    required this.subAccountId,
    required this.businessName,
    required this.accountOwnerName,
    required this.bankId,
    required this.bankName
});

  factory PaymentInfo.fromJson(Map<String, dynamic> json){
    return PaymentInfo(
      accountNumber : json["account_number"] ?? "",
      accountOwnerName: json["account_owner_name"] ?? "",
      bankName: json["bank_name"] ?? "",
      bankId: json["bank_id"] ?? "",
      subAccountId: json["sub_account_id"] ?? "",
      businessName: json["business_name"] ?? "",
      accountOwnerId: json["account_owner_id"] ?? 0,
    );
  }
}