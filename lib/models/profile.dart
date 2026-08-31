class Profile {
  final String id;
  String name;
  String url;
  String accountLabel;
  bool isRunning;

  Profile({
    required this.id,
    required this.name,
    required this.url,
    required this.accountLabel,
    this.isRunning = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'accountLabel': accountLabel,
        'isRunning': isRunning,
      };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        accountLabel: json['accountLabel'] ?? '',
        isRunning: json['isRunning'] ?? false,
      );
}
