class MemberModel {
  final String id;
  final String firts_name;
  final String last_name;
  final String avata_url;
  final String auth_token;

  const MemberModel({
    required this.id,
    required this.firts_name,
    required this.last_name,
    required this.avata_url,
    required this.auth_token,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firts_name': firts_name,
    'last_name': last_name,
    'avata_url': avata_url,
    'auth_token': auth_token,
  };

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      firts_name: json['firts_name'],
      last_name: json['last_name'],
      avata_url: json['avata_url'],
      auth_token: json['auth_token'],
    );
  }
}
