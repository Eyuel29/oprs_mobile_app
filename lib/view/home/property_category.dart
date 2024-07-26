import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';

List<Widget> getlistingModelDescription(Listing listingModel) {
  switch (listingModel.type) {
    case 'RESIDENTIAL':
      return[
        createDetail("Number of Bedrooms: ${listingModel.numberOfBedrooms}","assets/icons/bed.svg",2,10),
        createDetail("Number of Bathrooms: ${listingModel.numberOfBathrooms}","assets/icons/bath.svg",2,10),
        createDetail("Number of Kitchen: ${listingModel.numberOfKitchens}","assets/icons/silverware.svg",2,10),
        createDetail("Parking Areas: ${listingModel.parkingCapacity}","assets/icons/parking.svg",2,10),
        createDetail(
        listingModel.describingTerms.contains("Shared Room") ? "Shared Room(Looking for roomate)" : "Single Tenant or family",
        listingModel.describingTerms.contains("Shared Room") ? "assets/icons/shared_room.svg" : "assets/icons/room.svg",2,10),
        createDetail("Total floors: ${listingModel.numberOfFloors}","assets/icons/floors.svg",2,10),
        createDetail("Floor number: ${listingModel.floorNumber}","assets/icons/floors.svg",2,10),
      ];
  case 'STORAGE':
    return[
      createDetail("Security guards: ${listingModel.securityGuards}","assets/icons/guard.svg",2,10),
      createDetail("Loading docks: ${listingModel.loadingDocks}","assets/icons/forklift.svg",2,10),
      createDetail("Total floors: ${listingModel.numberOfFloors}","assets/icons/floors.svg",2,10),
    ];
  case 'COMMERCIAL':
    return[
      createDetail("Building Name: ${listingModel.buildingName}","assets/icons/building.svg",2,10),
      createDetail(listingModel.displays != 0 ? "Displays" : "No displays","assets/icons/building.svg",2,10),
      createDetail(listingModel.customerServiceDesks != 0 ? "Customer service desks" : "No Customer service desks","assets/icons/building.svg",2,10),
      createDetail(listingModel.backrooms != 0 ? "Backrooms" : "No backrooms","assets/icons/building.svg",2,10),
      createDetail("Floor number: ${listingModel.floorNumber}","assets/icons/floors.svg",2,10),
      createDetail("Tax responsibility: ${listingModel.taxResponsibility}","assets/icons/tax.svg",2,10),
      createDetail("Suitable for : ${listingModel.describingTerms.map((e) => "$e ,")}","assets/icons/property.svg",2,10),
    ];
    case 'EVENT' :
      return[
        createDetail("Guest capacity: ${listingModel.guestCapacity}","assets/icons/profile_male.svg",2,10),
        createDetail("Parking capacity: ${listingModel.parkingCapacity}","assets/icons/parking.svg",2,10),
        createDetail("Rest rooms: ${listingModel.numberOfBathrooms}","assets/icons/toilet.svg",2,10),
        createDetail("Flooor number: ${listingModel.floorNumber}","assets/icons/floors.svg",2,10),
      ];
    default :
      return [];
}
}


Widget createDetail(String detail, String asset, double margin, double padding){
  return Container(
    alignment: Alignment.centerLeft,
    margin:  EdgeInsets.symmetric(vertical: margin, horizontal: 0),
    padding: EdgeInsets.all(padding),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Wrap(
      children: [
        SizedBox(height: 20,width: 20,child: SvgPicture.asset(asset)),
        const SizedBox(width: 10,),
        Text(
          detail,
          style: const TextStyle(
              color: MyColors.headerFontColor,
              fontSize: 13,
          ),
        ),
      ],
    ),
  );
}