class User{
    int userId;
    String fullName;
    String phoneNumber;
    String gender;
    String dateOfBirth;
    String email;
    String dateJoined;
    int accountStatus;
    String region;
    String subCity;
    String woreda;
    String jobType;
    bool married;
    int userRole;
    String photoUrl;
    List<Map<String, String>> contactInfo;

    User({
      required this.userId,
      this.fullName = "",
      this.phoneNumber = "",
      this.gender = "",
      this.dateOfBirth = "",
      this.email = "",
      this.dateJoined = "",
      this.accountStatus = 1000,
      this.region = "",
      this.subCity = "BOLE",
      this.woreda = "",
      this.jobType = "",
      this.married = false,
      this.userRole = 1000,
      this.photoUrl = "",
      this.contactInfo = const []
    });

    factory User.fromJson(Map<String, dynamic> json) {
      var user = User(
        userId: json['user_id'] ?? 0,
        gender: json['gender'] ?? "",
        email: json['email'] ?? "",
        region: json['region'] ?? "",
        subCity: json['zone'] ?? "",
        woreda: json['woreda'] ?? "",
        jobType: json['job_type'] ?? "",
        fullName: json['full_name'] ?? "",
        photoUrl : json['photo_url'] ?? '',
        userRole: json['user_role'] ?? 1000,
        phoneNumber: json['phone_number'] ?? "",
        accountStatus: json['account_status'] ?? 2000,
        dateJoined: json['date_joined'] ?? "2024-12-12",
        dateOfBirth: DateTime.now().toString().substring(0,10),
        married: json["married"] == true || false ? json["married"] : json["married"] == 1 ? true : false,
        contactInfo: json['contact_infos'] != null ? json['contact_infos'][0]["name"] == null ? [] : List.from(json['contact_infos']) : []
      );

      return user;
   }
}