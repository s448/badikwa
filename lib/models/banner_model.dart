class BannerModel {
  final int id;
  final String url;
  final String redirectUrl;

  BannerModel({required this.id, required this.url, required this.redirectUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      url: json['url'],
      redirectUrl: json['redirectUrl'],
    );
  }
}
