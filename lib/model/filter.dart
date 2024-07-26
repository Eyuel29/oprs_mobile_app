import 'package:latlong2/latlong.dart';

class Filter{
  String propertyTypeOption, subCityOption, paymentCurrency;
  double minimumPrice, maximumPrice;
  LatLng selectedLocation;

  int cateringRooms, backStages, leaseDurationOption, backrooms, displays, customerServiceDesks,
  numberOfBedrooms, numberOfBathrooms, numberOfKitchens, parkingCapacity, ceilingHeightInMeters,
  numberOfFloors, floorNumber, loadingDocks, guestCapacity;

  Filter({
    this.propertyTypeOption = "",
    this.paymentCurrency = "",
    this.minimumPrice = 1000,
    this.maximumPrice = 150000,
    this.cateringRooms = 0,
    this.backStages = 0,
    this.backrooms = 0,
    this.displays = 0,
    this.customerServiceDesks = 0,
    this.numberOfBedrooms = 0,
    this.numberOfBathrooms = 0,
    this.numberOfKitchens = 0,
    this.parkingCapacity = 0,
    this.ceilingHeightInMeters = 0,
    this.numberOfFloors = 0,
    this.floorNumber = 0,
    this.loadingDocks = 0,
    this.guestCapacity = 0,
    this.leaseDurationOption = 0,
    this.subCityOption = "",
    this.selectedLocation = const LatLng(0,0)
  });

  Map<String, dynamic> toJson(){
    return {
    "type" : propertyTypeOption,
    "lease_duration_days" : leaseDurationOption,
    "sub_city" : subCityOption,
    "minimum_price" : minimumPrice,
    "maximum_price" : maximumPrice,
    "payment_currency" : paymentCurrency,
    "latitude" : selectedLocation.latitude.toString(),
    "longitude" : selectedLocation.longitude.toString(),
    "back_stages" : backStages,
    "backrooms" : backrooms,
    "displays" : displays,
    "catering_rooms" : cateringRooms,
    "customer_service_desks" : customerServiceDesks,
    "number_of_bedrooms" : numberOfBedrooms,
    "number_of_bathrooms" : numberOfBathrooms,
    "number_of_kitchens" : numberOfKitchens,
    "parking_capacity" : parkingCapacity,
    "ceiling_height_in_meters" : ceilingHeightInMeters,
    "number_of_floors" : numberOfFloors,
    "floor_number" : floorNumber,
    "loading_docks" : loadingDocks,
    "guest_capacity" : guestCapacity
    };
  }
}