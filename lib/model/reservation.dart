import 'package:oprs/model/user.dart';
class Reservation {
  final int reservationId;
  final int listingId;
  final int tenantId;
  final int leaseDurationDays;
  final String tenantName;
  final String listingTitle;
  final String description;
  final String date;
  final String additionalMessage;
  final String arrivalDate;
  final List<String> stayingDates;
  final int numberOfPeople, status;
  final String selectedPaymentMethod;
  final User tenant;

  Reservation({
    required this.listingTitle,
    required this.description,
    required this.listingId,
    required this.tenant,
    required this.tenantId,
    required this.leaseDurationDays,
    required this.tenantName,
    required this.date,
    this.selectedPaymentMethod = "Cash",
    this.reservationId = 0,
    this.status = 2000,
    this.stayingDates = const [],
    this.arrivalDate = "",
    this.additionalMessage ="",
    this.numberOfPeople = 0,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {

    User tenant = json["tenant"] == null ? User(userId: 0) : User.fromJson(Map.from(json["tenant"]));

    var reservation = Reservation(
      listingTitle : json["listing_title"] ?? "",
      description : json["description"] ?? "",
      reservationId : json["reservation_id"] ?? 0,
      listingId: json["listing_id"] ?? "",
      tenant: tenant,
      tenantName: json["tenant"]["full_name"] ?? "",
      leaseDurationDays: json["lease_duration_days"] ?? 1,
      tenantId: json["tenant_id"] ?? "",
      selectedPaymentMethod: json["selected_payment_method"] ?? "Cash",
      stayingDates: List.from(json["stay_dates"]) ?? [],
      arrivalDate: List.from(json["stay_dates"])[0] ?? "",
      date: json["created_at"] ?? "",
      additionalMessage: json["additional_message"] ?? "",
      numberOfPeople:  json["price_offer"] ?? 0,
    );
    return reservation;
  }
}