class ReferralModel {
  ReferralModel({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
    required this.referrer,
    required this.referred,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
        id: json['id'] as int,
        dateCreated: DateTime.parse(json['date_created'] as String),
        dateModified: DateTime.parse(json['date_modified'] as String),
        referrer:
            ReferrerModel.fromJson(json['referrer'] as Map<String, dynamic>),
        referred:
            ReferredModel.fromJson(json['referred'] as Map<String, dynamic>),
      );
  final int id;
  final DateTime dateCreated;
  final DateTime dateModified;
  final ReferrerModel referrer;
  final ReferredModel referred;
}

class ReferrerModel {
  ReferrerModel({
    required this.firstName,
    required this.lastName,
  });

  factory ReferrerModel.fromJson(Map<String, dynamic> json) => ReferrerModel(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
      );
  final String firstName;
  final String lastName;
}

class ReferredModel {
  ReferredModel({
    required this.firstName,
    required this.lastName,
  });

  factory ReferredModel.fromJson(Map<String, dynamic> json) => ReferredModel(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
      );
  final String firstName;
  final String lastName;
}
