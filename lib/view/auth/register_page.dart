import 'package:email_validator/email_validator.dart';
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
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/auth/verify_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  List<XFile> photos = [];
  TextEditingController dateInputController = TextEditingController(
    text: DateTime.now().toString().substring(0,10)
  );

  DateTime birthDate = DateTime.now();
  Map<String, String> inputErrors = <String, String>{
    "fullName" : "",
    "email" : "",
    "phoneNumber" : "",
    "age" : "",
    "woreda" : "",
    "password" : "",
    "password2" : "",
    "jobType" : "",
    "telegram" : "",
    "whatsApp" : "",
    "birthDate":""
  };

  List<SelectionChip> userRoleOptions = [
    SelectionChip("Property Owner", false),
    SelectionChip("Tenant", true),
  ];
  List<SelectionChip> maritalStatusOptions = [
    SelectionChip("Married", false),
    SelectionChip("Not Married", false),
  ];
  final List<String> subCityOptions = ["ADDIS KETEMA",
  "AKAKY KALITI",
  "ARADA",
  "BOLE",
  "GULLELE",
  "KIRKOS",
  "KOLFE KERANIO",
  "LIDETA",
  "NIFAS SILK-LAFTO",
  "YEKA",
  "LEMI KURA"
  ];

  List<String> genderOptions = ['MALE', 'FEMALE'];
  bool registerWaiting = false, married = false, obsecureText = true;
  String fullName = "", bio = "", subCity = "KOLFE KERANIO", gender = "MALE",
      email = "", woreda = "", password = "", password2 = "", jobType = "";
  int phoneNumber = 0, userRole = 1000, currentStep = 0;
  Map<String, String> socials = {"whatsApp" : "", "telegram" : ""};

  @override
  Widget build(BuildContext context) {
    CustomTextInput fullNameInput = CustomTextInput(
      hintText: 'Full Name',
      inputType: TextInputType.name,
      obscureText: false,
      initialValue: fullName,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && text.length < 5){
            inputErrors["fullName"] = "Your name is too short!";
          } else {
            inputErrors["fullName"] = "";
          }
          fullName = text;
        });
      },
      errorText: inputErrors["fullName"]!.isNotEmpty ? inputErrors["fullName"] : null,
    );
    CustomTextInput emailInput = CustomTextInput(
      hintText: 'Email',
      inputType: TextInputType.emailAddress,
      obscureText: false,
      maxValue: 100,
      initialValue: email,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && !EmailValidator.validate(text)){
            inputErrors["email"] = "Invalid email";
          } else {
            inputErrors["email"] = "";
          }
          email = text;
        });
      },
      errorText: inputErrors["email"]!.isNotEmpty ? inputErrors["email"] : null,
    );
    DropDownButtonForm genderInput = DropDownButtonForm(
      allOptions: genderOptions,
      initialValue: gender.isNotEmpty ? gender : genderOptions[0],
      hintText: "Select Gender",
      onChanged: (selected){
        setState(() {
          gender = selected!;
        });
      },
      errorText: null,
    );
    TextFormField birthDateInput = TextFormField(
      keyboardType: TextInputType.datetime,
      style: const TextStyle(
          fontSize: 14,
          color: MyColors.bodyFontColor
      ),
      obscureText: false,
      controller: dateInputController,
      decoration: InputDecoration(
        fillColor: MyColors.mainThemeLightColor,
        labelText: "Date of Birth",
        labelStyle: const TextStyle(
            fontSize: 14,
            color: MyColors.bodyFontColor
        ),
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
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && text.length < 10){
            inputErrors["birthDate"] = "Invalid date!";
          } else {
            inputErrors["birthDate"] = "";
          }
        });
      },
      onTap:  () async {
        showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: birthDate,
        ).then((value){
          if(DateTime.now().year - value!.year < 18){
            SnackBarMessage.make(context, "You're not eligible to create an account!");
            setState(() {
              inputErrors["birthDate"] = "Not eligible!";
            });
            return;
          }
          setState(() {
            inputErrors["birthDate"] = "";
            birthDate = value ?? birthDate;
            dateInputController.text = "${birthDate.year}-${birthDate.month}-${birthDate.day}";
          });
        });
      },
    );
    ChipSelectionInput marriedInput = ChipSelectionInput(
      options: maritalStatusOptions,
      onSelected: (options){
        for (var element in options) {
          if(element.selected){
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
      initialValue: subCity.isNotEmpty ? subCity : subCityOptions[0],
      hintText: "Select Sub-city",
      onChanged: (selected){
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
      initialValue: woreda,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && !isInteger(text)){
            inputErrors["woreda"] = "Woreda must be numeric!";
          } else {
            inputErrors["woreda"] = "";
          }
          woreda = text;
        });
      },
      errorText: inputErrors["woreda"]!.isNotEmpty ? inputErrors["woreda"] : null,
    );
    CustomTextInput phoneInput = CustomTextInput(
      hintText: 'Phone Number',
      inputType: TextInputType.phone,
      obscureText: false,
      maxValue: 10,
      initialValue: phoneNumber == 0 ? "" : phoneNumber.toString(),
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && (!isInteger(text) || text.length < 10)){
            inputErrors["phoneNumber"] = "Invalid Phone number";
          } else {
            inputErrors["phoneNumber"] = "";
          }
          phoneNumber = (isInteger(text) && text.length >= 10)
              ? int.parse(text) : 0;
        });
      },
      errorText: inputErrors["phoneNumber"]!.isNotEmpty ? inputErrors["phoneNumber"] : null,
    );
    ChipSelectionInput userRoleIuput = ChipSelectionInput(
      options: userRoleOptions,
      onSelected: (options){
        for (var element in options) {
          if(element.selected){
            setState(() {
              userRole = element.label == "Tenant" ? 1000 : 2000;
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
    CustomTextInput jobTypeInput = CustomTextInput(
      hintText: 'Job Description',
      inputType: TextInputType.text,
      obscureText: false,
      initialValue: jobType,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && text.length < 5){
            inputErrors["jobType"] = "Job description is too short!";
          } else {
            inputErrors["jobType"] = "";
          }
          jobType = text;
        });
      },
      errorText: inputErrors["jobType"]!.isNotEmpty ? inputErrors["jobType"] : null,
    );
    CustomTextInput password1Input = CustomTextInput(
      hintText: 'Password',
      inputType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      initialValue: password,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && !isPasswordStrong(text)){
            inputErrors["password"] = "Password is weak!";
          } else {
            inputErrors["password"] = "";
          }
          password = text;
        });
      },
      errorText: inputErrors["password"]!.isNotEmpty ? inputErrors["password"] : null,
    );
    CustomTextInput password2Input = CustomTextInput(
      hintText: 'Repeat Password',
      inputType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      initialValue: password2,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && password != text){
            inputErrors["password2"] = "Passwords do not march!";
          } else {
            inputErrors["password2"] = "";
          }
          password2 = text;
        });
      },
      errorText: inputErrors["password2"]!.isNotEmpty ? inputErrors["password2"] : null,
    );
    CustomTextInput telegramInput = CustomTextInput(
      hintText: 'Telegram Username or Phone',
      inputType: TextInputType.text,
      maxValue: 15,
      obscureText: false,
      initialValue: socials["telegram"]!,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && text.length < 5){
            inputErrors["telegram"] = "Address is too short!";
          } else {
            inputErrors["telegram"] = "";
          }
          socials["telegram"] = text;
        });
      },
      errorText: inputErrors["telegram"]!.isNotEmpty ? inputErrors["telegram"] : null,
    );
    CustomTextInput whatsAppInput = CustomTextInput(
      hintText: 'Whatsapp Number',
      inputType: TextInputType.number,
      obscureText: false,
      maxValue: 10,
      initialValue: socials["whatsApp"]!,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && (!isInteger(text) || text.length < 10)){
            inputErrors["whatsApp"] = "Invalid number!";
          } else {
            inputErrors["whatsApp"] = "";
          }
          socials["whatsApp"] = text;
        });
      },
      errorText: inputErrors["whatsApp"]!.isNotEmpty ? inputErrors["whatsApp"] : null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: MyColors.mainThemeDarkColor,
         foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  child: Stepper(
                    physics: const ClampingScrollPhysics(),
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    margin : const EdgeInsets.symmetric(horizontal: 0),
                    controlsBuilder: (context, details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: registerWaiting || currentStep < 1 ? null : details.onStepCancel,
                              isLoading: false,
                              loadingText: "Waiting",
                              loadingTextColor: MyColors.mainThemeDarkColor,
                              buttonText: "Back",
                              buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                              buttonTextColor: MyColors.mainThemeLightColor,
                              insetV: 25,
                              radius: 10,
                            ),
                          ),
                          const SizedBox(width: 10),
                          currentStep != 5 ?
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: details.onStepContinue,
                              isLoading: false,
                              loadingText: "Waiting",
                              loadingTextColor: MyColors.mainThemeDarkColor,
                              buttonText: "Next",
                              buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                              buttonTextColor: MyColors.mainThemeLightColor,
                              insetV: 25,
                              radius: 10,
                            ),
                          ) :
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: registerWaiting ? null : (){
                                handleRegister(context);
                              },
                              isLoading: registerWaiting ,
                              loadingText: "Waiting",
                              loadingTextColor: MyColors.mainThemeDarkColor,
                              buttonText: "Finish",
                              buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                              buttonTextColor: MyColors.mainThemeLightColor,
                              insetV: 25,
                              radius: 10,
                            ),
                          ),
                        ],
                      );
                    },
                    onStepContinue: () {
                      setState(() {
                        if (currentStep < 5) { currentStep += 1; }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (currentStep > 0) { currentStep -= 1; }
                      });
                    },
                    steps: <Step>[
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Personal Information",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            fullNameInput,
                            emailInput,
                            const SizedBox(height: 10),
                            genderInput,
                            const SizedBox(height: 25),
                            birthDateInput,
                            const SizedBox(height: 25),
                          ],
                        ),
                        isActive: currentStep == 0,
                      ),
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Address Details",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            subCityInput,
                            const SizedBox(height: 10),
                            woredaInput,
                            phoneInput,
                            const SizedBox(height: 15),
                          ],
                        ),
                        isActive: currentStep == 1,
                      ),
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Select Account Type",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            userRoleIuput,
                            const SizedBox(height: 15),
                          ],
                        ),
                        isActive: currentStep == 2,
                      ),
                      userRole == 1000 ?
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Enter Your Job Description",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            jobTypeInput,
                            const SizedBox(height: 15),
                            const Text("Marital Status",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            marriedInput,
                            const SizedBox(height: 15),
                          ],
                        ),
                        isActive: currentStep == 3,
                      ) :
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Enter additional Addresses (optional)",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            telegramInput,
                            whatsAppInput,
                            const SizedBox(height: 15),
                          ],
                        ),
                        isActive: currentStep == 3,
                      ),
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text("Add Profile Picture",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ProfileImageInput(
                              onImagesSelected: (images) {
                                setState(() { photos = images;});
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                        isActive: currentStep == 4,
                      ),
                      Step(
                        title: const Text(''),
                        content: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyColors.headerFontColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            password1Input,
                            password2Input,
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: !obsecureText,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      obsecureText = !obsecureText;
                                    });
                                  },
                                ),
                                const Expanded(
                                    child: Text("Show Password")
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                        isActive: currentStep == 5,
                      )
                    ],
                  ),
                )
              )
            ],
          ),
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

  bool checkEmptyInput(){
    return (
      fullName.isEmpty ||
      email.isEmpty ||
      gender.isEmpty ||
      birthDate.compareTo(DateTime.now()) == 0 ||
      ( userRole == 1000 &&
          (!maritalStatusOptions[0].selected &&
              !maritalStatusOptions[1].selected ||
              jobType.isEmpty)
      ) ||
      subCity.isEmpty ||
      phoneNumber == 0 ||
      woreda.isEmpty ||
      !userRoleOptions[0].selected && !userRoleOptions[1].selected ||
      password.isEmpty ||
      password2.isEmpty );
  }

  String checkInputErrors(){
    String errorFound = "";
    inputErrors.forEach((key, value){
      if(value.isNotEmpty){
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
        dio.MultipartFile mFile = dio.MultipartFile.fromBytes(
            bytes, filename: photo.name,
            contentType:  MediaType("image", "jpeg"));
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
      "job_type": userRole == 2000 ? "Property Owner" : jobType,
      "date_of_birth" : birthDate.toString(),
      "user_role": userRole,
      "region": "Addis Ababa",
      "married": married,
      "password": password,
      "socials" : socials,
      "files": files
    });
    return formData;
  }

  void handleRegister(BuildContext context) async{
    if(checkEmptyInput()){
      SnackBarMessage.make(context, "Please check the required inputs!");
      return;
    }

    if(checkInputErrors().isNotEmpty){
      String message = checkInputErrors();
      SnackBarMessage.make(context, message);
      return;
    }

    setState(() { registerWaiting = true; });
    dio.FormData userMap = await createUserMap();

    AuthRepo().register(userMap).then((response){
      setState(() { registerWaiting = false; });
      if(response["status"] != 200){
        SnackBarMessage.make(context, response["message"]);
        return;
      }

      Navigator.push( context,
        MaterialPageRoute(
          builder: (context) => const VerifyPage(
              verificationAvailable: true
          )
        )
      );
    });
  }
}