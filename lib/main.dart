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
  // Future que usará el FutureBuilder para saber cuando llegan los datos
  late Future<RandomUser> futureUser;
  int currentProfileIndex = 0; // Índice del perfil actual (0, 1, o 2)

  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, se carga el primer perfil
    futureUser = getProfile(currentProfileIndex);
  }

  /// Función que retorna un perfil según el índice (0, 1, o 2)
  Future<RandomUser> getProfile(int index) async {
    // Simula una pequeña demora para mantener el FutureBuilder
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Retorna el perfil correspondiente al índice
    switch (index) {
      case 0:
        // Perfil 1 - Juan Almanza
        return RandomUser(
          fullName: 'Juan Almanza',
          email: 'Almanzasalinas123@gmail.com',
          country: 'Colombia',
          imageUrl: 'assets/images/profile.jpg',
          phone: '+57 315 047 0429',
          city: 'Campoalegre',
        );
      case 1:
        // Perfil 2 - Aquí puedes agregar los datos del segundo perfil
        return RandomUser(
          fullName: 'Nombre Perfil 2',
          email: 'perfil2@ejemplo.com',
          country: 'Colombia',
          imageUrl: 'assets/images/profile.jpg', // Puedes agregar otra imagen
          phone: '+57 300 000 0000',
          city: 'Ciudad Perfil 2',
        );
      case 2:
        // Perfil 3 - Aquí puedes agregar los datos del tercer perfil
        return RandomUser(
          fullName: 'Nombre Perfil 3',
          email: 'perfil3@ejemplo.com',
          country: 'Colombia',
          imageUrl: 'assets/images/profile.jpg', // Puedes agregar otra imagen
          phone: '+57 300 000 0000',
          city: 'Ciudad Perfil 3',
        );
      default:
        return getProfile(0);
    }
  }

  /// Función para cambiar al siguiente perfil (cicla entre 0, 1, 2)
  void _loadNewUser() {
    setState(() {
      currentProfileIndex = (currentProfileIndex + 1) % 3; // Cicla entre 0, 1, 2
      futureUser = getProfile(currentProfileIndex);
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
                            backgroundImage: user.imageUrl.startsWith('http')
                                ? NetworkImage(user.imageUrl) as ImageProvider
                                : AssetImage(user.imageUrl) as ImageProvider,
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
                  // Botón para cambiar entre perfiles
                  ElevatedButton.icon(
                    onPressed: _loadNewUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Siguiente perfil'),
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
