/// Modelo que representa la información básica de un usuario aleatorio
/// obtenido desde la API https://randomuser.me/api/
class RandomUser {
  final String fullName; // Nombre completo (nombre + apellido)
  final String email;    // Correo electrónico
  final String country;  // País del usuario
  final String imageUrl; // URL de la imagen de perfil
  final String phone;    // Teléfono del usuario
  final String city;     // Ciudad del usuario

  RandomUser({
    required this.fullName,
    required this.email,
    required this.country,
    required this.imageUrl,
    required this.phone,
    required this.city,
  });

  /// Crea un RandomUser a partir de un Map (JSON) que corresponde
  /// a un elemento del arreglo "results" de la API.
  factory RandomUser.fromJson(Map<String, dynamic> json) {
    final name = json["name"];       // Contiene first y last
    final location = json["location"]; // Contiene country y city
    final picture = json["picture"];  // Contiene large

    final firstName = name["first"];
    final lastName = name["last"];
    final countryName = location["country"];
    final cityName = location["city"];
    final image = picture["large"];

    return RandomUser(
      fullName: "$firstName $lastName",
      email: json["email"],
      country: countryName,
      imageUrl: image,
      phone: json["phone"],
      city: cityName,
    );
  }
}

