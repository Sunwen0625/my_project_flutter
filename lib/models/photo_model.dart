class PhotoModel {
  final String imagePath;
  final String cutImagePath;
  final String date;
  final String address;
  final String longitude;
  final String latitude;
  final String licensePlate;


  PhotoModel( {
    required this.imagePath,
    required this.cutImagePath,
    required this.date,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.licensePlate,
  });
}
