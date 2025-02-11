import 'package:latlong2/latlong.dart';

class Listing {
      String type,
      title,
      description,
      subCity,
      woreda,
      areaName,
      pricePerDuration,
      paymentCurrency,
      taxResponsibility,
      buildingName,
      dateCreate,
      dateModified;
      int listingId,
      ownerId,
      floorNumber,
      cateringRooms,
      reviewCount,
      averageRating,
      backStages,
      totalAreaSquareMeter,
      distanceFromRoadInMeters,
      leaseDurationDays,
      securityGuards,
      backrooms,
      displays,
      storageCapacitySquareMeter,
      customerServiceDesks,
      numberOfBedrooms,
      numberOfBathrooms,
      numberOfKitchens,
      parkingCapacity,
      ceilingHeightInMeters,
      numberOfFloors,
      loadingDocks,
      listingStatus,
      guestCapacity,
      views;
      List<String> urlImages,
      amenities,
      describingTerms;
      LatLng? latLng;

   Listing({
       required this.type,
       this.dateCreate = "",
       this.dateModified = "",
       this.listingId = 0, this.ownerId = 0,
       this.title = "", this.description = "",
       this.subCity = "", this.woreda = "",
       this.areaName = "", this.pricePerDuration = "",
       this.paymentCurrency = "", this.taxResponsibility = '',
       this.buildingName = '', this.totalAreaSquareMeter = 0,
       this.listingStatus = 1000, this.distanceFromRoadInMeters = 0,
       this.customerServiceDesks = 0, this.leaseDurationDays = 1,
       this.numberOfBathrooms = 0, this.numberOfBedrooms = 0,
       this.numberOfKitchens = 0, this.securityGuards = 0,
       this.cateringRooms = 0, this.floorNumber = 0,
       this.backStages = 0, this.backrooms = 0,
       this.displays = 0, this.views = 0,
       this.storageCapacitySquareMeter = 0, this.parkingCapacity = 0,
       this.ceilingHeightInMeters = 0, this.numberOfFloors = 0,
       this.loadingDocks = 0, this.guestCapacity = 0,
       this.reviewCount = 0, this.averageRating = 0,
       this.amenities = const [], this.describingTerms = const [],
       this.urlImages = const [], this.latLng = const LatLng(9.031189291103262,38.752624277434705),
      }
     );

 factory Listing.fromJson(json) {

   return Listing(
     listingId : json['listing_id'] ?? 0,
     type : json['type'] ?? "",
     title : json['title'] ?? "",
     cateringRooms : json["catering_rooms"] ?? 0,
     backStages : json["back_stages"] ?? 0,
     description : json['description'] ?? "",
     ownerId : json["owner_id"] ?? 0,
     subCity : json['sub_city'] ?? "KOLFE KERANIO",
     woreda : json['woreda'] ?? "",
     areaName : json['area_name'] ?? "",
     pricePerDuration : json['price_per_duration'] ?? "0",
     paymentCurrency : json['payment_currency'] ?? "ETB",
     taxResponsibility : json['tax_responsibility'] ?? "Owner",
     totalAreaSquareMeter : json['total_area_square_meter'] ?? 0,
     buildingName : json['building_name'] ?? "",
     floorNumber : json['floor_number'] ?? 0,
     reviewCount : json["review_count"] ?? 0,
     averageRating : json["average_rating"] ?? 0,
     distanceFromRoadInMeters : json['distance_from_road_in_meters'] ?? 0,
     leaseDurationDays : json['lease_duration_days'] ?? 0,
     securityGuards : json['security_guards'] ?? 0,
     backrooms : json['backrooms'] ?? 0,
     displays : json['displays'] ?? 0,
     storageCapacitySquareMeter : json['storage_capacity_square_meter'] ?? 0,
     customerServiceDesks : json['customer_service_desks'] ?? 0,
     numberOfBedrooms : json['number_of_bedrooms'] ?? 0,
     numberOfBathrooms : json['number_of_bathrooms'] ?? 0,
     numberOfKitchens : json['number_of_kitchens'] ?? 0,
     parkingCapacity : json['parking_capacity'] ?? 0,
     ceilingHeightInMeters : json['ceiling_height_in_meter'] ?? 0,
     numberOfFloors : json['number_of_floors'] ?? 0,
     listingStatus: json['listing_status'] ?? 0,
     loadingDocks : json['loading_docks'] ?? 0,
     guestCapacity : json['guest_capacity'] ?? 0,
     dateCreate : json["created_at"] ?? DateTime.now().toString(),
     dateModified : json["updated_at"] ?? DateTime.now().toString(),
     views : json['views'] ?? 0,
     latLng : LatLng(double.parse(json["latitude"]), double.parse(json["longitude"])),
     urlImages : json['photo_urls'] != null ? List<String>.from(json['photo_urls']) : [],
     amenities : json['amenities'] != null ? List<String>.from(json['amenities']) : [],
     describingTerms : json['describing_terms'] != null ? List<String>.from(json['describing_terms']) : [],
   );
 }
}