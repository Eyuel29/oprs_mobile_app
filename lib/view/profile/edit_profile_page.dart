import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/components/input/drop_down_input.dart';
import 'package:oprs/components/input/profile_image_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/user.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/auth/verify_page.dart';
import 'package:oprs/view/view_constants.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User user;
  late List<XFile> myPhoto;
  List<XFile> photos = [];
  Map<String, String> inputErrors = <String, String>{
    "fullName": "",
    "email": "",
    "phoneNumber": "",
    "woreda": "",
    "jobType": "",
    "birthDate": "",
  };

  List<SelectionChip> maritalStatusOptions = [
    SelectionChip("Married", false),
    SelectionChip("Not Married", false),
  ];

  final List<String> subCityOptions = List.from(subCityOptionsConstant);
  List<String> genderOptions = ['MALE', 'FEMALE'];
  bool updateProfileWaiting = false, married = false;
  String subCity = "ADDIS KETEMA",
    gender = "MALE",
    fullName = "",
    email = "",
    woreda = "",
    jobType = "";
  int phoneNumber = 0, age = 0;
  DateTime birthDate = DateTime.now();
  TextEditingController dateInputController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  @override
  void initState() {
    super.initState();
    try {
      user = widget.user;
      File? myFile;
      myFile = File.fromUri(Uri.parse(user.photoUrl));
      myPhoto.add(XFile(myFile.path));
    } catch (error) {
      myPhoto = [];
    }
    if(user.married){
      maritalStatusOptions.where((e) => e.label == "Married").first.selected = true;
    }else{
     maritalStatusOptions.where((e) => e.label == "Not Married").first.selected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomTextInput fullNameInput = CustomTextInput(
      hintText: 'Full Name',
      inputType: TextInputType.name,
      obscureText: false,
      initialValue: user.fullName,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && text.length < 5) {
            inputErrors["fullName"] = "Your name is too short!";
          } else {
            inputErrors["fullName"] = "";
          }
          fullName = text;
        });
      },
      errorText:
          inputErrors["fullName"]!.isNotEmpty ? inputErrors["fullName"] : null,
    );
    TextFormField birthDateInput = TextFormField(
      keyboardType: TextInputType.datetime,
      style: const TextStyle(fontSize: 14, color: MyColors.bodyFontColor),
      obscureText: false,
      controller: dateInputController,
      decoration: InputDecoration(
        fillColor: MyColors.mainThemeLightColor,
        labelText: "Date of Birth",
        labelStyle:
            const TextStyle(fontSize: 14, color: MyColors.bodyFontColor),
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: MyColors.mainThemeDarkColor, width: 5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.mainThemeDarkColor, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        errorText: inputErrors["birthDate"]!.isNotEmpty ? inputErrors["birthDate"] : null,
      ),
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && text.length < 10) {
            inputErrors["birthDate"] = "Invalid date!";
          } else {
            inputErrors["birthDate"] = "";
          }
        });
      },
      onTap: () async {
        showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: birthDate,
        ).then((value) {
          setState(() {
            birthDate = value ?? birthDate;
            dateInputController.text =
                "${birthDate.year}-${birthDate.month}-${birthDate.day}";
          });
        });
      },
    );
    ChipSelectionInput marriedInput = ChipSelectionInput(
      options: maritalStatusOptions,
      onSelected: (options) {
        for (var element in options) {
          if (element.selected) {
            setState(() {
              married = element.label == "Married";
            });
          }
        }
      },
      radius: 10,
      gap: 8,
      padding: 14,
      fontSize: 16,
      singleSelection: true,
      lightColor: MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: 1,
    );
    DropDownButtonForm subCityInput = DropDownButtonForm(
      allOptions: subCityOptions,
      initialValue: user.subCity.isNotEmpty ? user.subCity : subCityOptions[0],
      hintText: "Select Sub-city",
      onChanged: (selected) {
        setState(() {
          subCity = selected!;
        });
      },
      errorText: null,
    );
    CustomTextInput woredaInput = CustomTextInput(
      hintText: 'Woreda',
      inputType: TextInputType.number,
      obscureText: false,
      initialValue: user.woreda,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && !isInteger(text)) {
            inputErrors["woreda"] = "Woreda must be numeric!";
          } else {
            inputErrors["woreda"] = "";
          }
          woreda = text;
        });
      },
      errorText:
          inputErrors["woreda"]!.isNotEmpty ? inputErrors["woreda"] : null,
    );
    CustomTextInput phoneInput = CustomTextInput(
      hintText: 'Phone Number',
      inputType: TextInputType.phone,
      obscureText: false,
      maxValue: 10,
      initialValue: user.phoneNumber,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && (!isInteger(text) || text.length < 10)) {
            inputErrors["phoneNumber"] = "Invalid Phone number";
          } else {
            inputErrors["phoneNumber"] = "";
          }
          user.phoneNumber = (isInteger(text) && text.length >= 10) ? text : "";
        });
      },
      errorText: inputErrors["phoneNumber"]!.isNotEmpty
          ? inputErrors["phoneNumber"]
          : null,
    );
    CustomTextInput jobTypeInput = CustomTextInput(
      hintText: 'Job Description',
      inputType: TextInputType.text,
      obscureText: false,
      initialValue: user.jobType,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && text.length < 5) {
            inputErrors["jobType"] = "Job description is too short!";
          } else {
            inputErrors["jobType"] = "";
          }
          jobType = text;
        });
      },
      errorText:
          inputErrors["jobType"]!.isNotEmpty ? inputErrors["jobType"] : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageInput(
                currentImages: myPhoto,
                onImagesSelected: (images) {
                  setState(() {
                    photos = images;
                  });
                },
              ),
              fullNameInput,
              const SizedBox(height: 10),
              birthDateInput,
              const SizedBox(height: 20),
              subCityInput,
              const SizedBox(height: 20),
              woredaInput,
              phoneInput,
              jobTypeInput,
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  "Marital Status",
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.headerFontColor
                  ),
                ),
              ),
              const SizedBox(height: 10),
              marriedInput,
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: updateProfileWaiting ? null : () {
                        Navigator.pop(context);
                      },
                      isLoading: false,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Cancel",
                      buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                      buttonTextColor: MyColors.mainThemeLightColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: updateProfileWaiting ? null : () {
                        handleRegister(context);
                      },
                      isLoading: updateProfileWaiting,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Done",
                      buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                      buttonTextColor: MyColors.mainThemeLightColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  bool isPasswordStrong(String input) {
    if (input.length < 6) return false;
    bool hasNumeric = input.contains(RegExp(r'[0-9]'));
    bool hasCapital = input.contains(RegExp(r'[A-Z]'));
    return hasNumeric && hasCapital;
  }

  bool isInteger(String input) {
    RegExp regExp = RegExp(r'^-?\d+$');
    return regExp.hasMatch(input);
  }

  bool checkEmptyInput() {
    return (fullName.isEmpty ||
        age == 0 ||
        (user.userRole == 1000 &&
            (!maritalStatusOptions[0].selected &&
                    !maritalStatusOptions[1].selected ||
                jobType.isEmpty)) ||
        subCity.isEmpty ||
        phoneNumber == 0 ||
        woreda.isEmpty
    );
  }

  String checkInputErrors() {
    String errorFound = "";
    inputErrors.forEach((key, value) {
      if (value.isNotEmpty) {
        errorFound = value;
      }
    });
    return errorFound;
  }

  Future<dio.FormData> createUserMap() async {
    List<dio.MultipartFile> files = [];
    if (photos.isNotEmpty) {
      for (var photo in photos) {
        List<int> bytes = await photo.readAsBytes();
        dio.MultipartFile mFile = dio.MultipartFile.fromBytes(bytes,
            filename: photo.name, contentType: MediaType("image", "jpeg"));
        files.add(mFile);
      }
    }

    dio.FormData formData = dio.FormData.fromMap({
      "full_name": fullName,
      "gender": gender,
      "phone_number": phoneNumber,
      "email": email,
      "zone": subCity,
      "woreda": woreda,
      "job_type": user.userRole == 2000 ? "Property Owner" : jobType,
      "age": age,
      "user_role": user.userRole,
      "region": "Addis Ababa",
      "married": married,
      "socials": [],
      "files": files
    });
    return formData;
  }

  void handleRegister(BuildContext context) async {
    if (checkEmptyInput()) {
      SnackBarMessage.make(context, "Please check the required inputs!");
      return;
    }

    if (checkInputErrors().isNotEmpty) {
      String message = checkInputErrors();
      SnackBarMessage.make(context, message);
      return;
    }

    setState(() {
      updateProfileWaiting = true;
    });
    dio.FormData userMap = await createUserMap();

    AuthRepo().register(userMap).then((response) {
      setState(() {
        updateProfileWaiting = false;
      });
      if (response["status"] != 200) {
        SnackBarMessage.make(context, response["message"]);
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const VerifyPage(verificationAvailable: true)
          )
      );
    });
  }
}
