class ImageModel{
  final int id;
  final String url;

  const ImageModel(
    {
      required this.id,
      required this.url, 
    }
  );

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
      id: json['id'],
      url: json['filename'],
  );
}