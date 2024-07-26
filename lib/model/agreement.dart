import 'package:oprs/model/user.dart';

class Agreement{
  final int agreementId;
  final int tenantId;
  final int ownerId;
  final int listingId;
  final int agreementStatus;
  final String pricePerDuration;
  final String paymentCurrency;
  final String subAccountId;
  final User owner;
  final User tenant;
  final DateTime leaseStartDate;
  final DateTime leaseEndDate;

  Agreement({
    required this.agreementId,
    required this.tenantId,
    required this.ownerId,
    required this.listingId,
    required this.agreementStatus,
    required this.leaseStartDate,
    required this.leaseEndDate,
    required this.owner,
    required this.tenant,
    required this.pricePerDuration,
    required this.paymentCurrency,
    required this.subAccountId,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {

    return Agreement(
        owner: User.fromJson(json["owner"]),
        tenant: User.fromJson(json["tenant"]),
        agreementId : json["agreement_id"] ?? 0,
        tenantId : json["tenant_id"] ?? 0,
        ownerId : json["owner_id"] ?? 0,
        listingId : json["listing_id"] ?? 0,
        agreementStatus : json["agreement_status"] ?? 1000,
        leaseStartDate : DateTime.fromMicrosecondsSinceEpoch(json["lease_start_date"]  * 1000 ?? 1719672112781000,isUtc: true),
        leaseEndDate : DateTime.fromMicrosecondsSinceEpoch(json["lease_end_date"] * 1000 ?? 1719672112781000,isUtc: true),
        pricePerDuration : json["price_per_duration"] ?? "1000",
        paymentCurrency : json["payment_currency"] ?? "ETB",
        subAccountId : json["sub_account_id"] ?? "-",
    );
  }
}
