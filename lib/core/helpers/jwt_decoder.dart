import 'package:jwt_decoder/jwt_decoder.dart';

Future<String?> getUserIdFromToken(String token) async {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

  // Your backend uses nameidentifier as the user id
  return decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
}
