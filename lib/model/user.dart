class appUser {
  final String id;
  final String userName;
  final String email;
  final String imageUrl;
  final String address;
  final String role;
  int? score;
  List<String>? likedReports;

  appUser({
    required this.id,
    required this.userName,
    required this.email,
    required this.imageUrl,
    required this.address,
    required this.role,
    this.score,
    this.likedReports,
  });
}
