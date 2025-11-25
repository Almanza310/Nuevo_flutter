import 'dart:convert'; // Para jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Paquete http
import 'random_user.dart'; // Nuestro modelo

void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random User Lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomUserPage(),
    );
  }
}

/// Pantalla principal que muestra un usuario aleatorio
class RandomUserPage extends StatefulWidget {
  const RandomUserPage({super.key});

  @override
  State<RandomUserPage> createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  // Future que usará el FutureBuilder para saber cuándo llegan los datos
  late Future<RandomUser> futureUser;

  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, se llama por primera vez a la API
    futureUser = fetchRandomUser();
  }

  /// Función que consume la API https://randomuser.me/api/
  /// y devuelve un objeto RandomUser
  Future<RandomUser> fetchRandomUser() async {
    const url = 'https://randomuser.me/api/';
    // 1. Petición GET
    final response = await http.get(Uri.parse(url));
    // 2. Verificar código de estado
    if (response.statusCode == 200) {
      // 3. Convertir body (String) a Map con jsonDecode
      final Map<String, dynamic> data = jsonDecode(response.body);
      // 4. Tomar el primer usuario del arreglo "results"
      final userJson = data["results"][0];
      // 5. Convertirlo a nuestro modelo
      return RandomUser.fromJson(userJson);
    } else {
      // Si la respuesta no fue exitosa, se lanza un error
      throw Exception('Error al cargar el usuario. Código: ${response.statusCode}');
    }
  }

  /// Función para volver a cargar un usuario nuevo (se usará en el botón)
  void _loadNewUser() {
    setState(() {
      futureUser = fetchRandomUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random User Lab'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<RandomUser>(
          future: futureUser, // El future que definimos arriba
          builder: (context, snapshot) {
            // 1. Mientras se espera la respuesta de la API
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // 2. Si ocurrió un error
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  const Text('Ocurrió un error al cargar el usuario'),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNewUser,
                    child: const Text('Reintentar'),
                  ),
                ],
              );
            }

            // 3. Si los datos llegaron correctamente
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Foto de perfil
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          const SizedBox(height: 16),
                          // Nombre completo
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          // Correo
                          Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 8),
                          // Teléfono
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone,
                                  size: 18, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(
                                user.phone,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Ciudad
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_city,
                                  size: 18, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                user.city,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // País
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                user.country,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Botón para pedir un nuevo usuario
                  ElevatedButton.icon(
                    onPressed: _loadNewUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nuevo usuario'),
                  ),
                ],
              );
            }

            // 4. Caso extremo: sin datos ni error
            return const Text('No hay datos para mostrar.');
          },
        ),
      ),
    );
  }
}
