import 'package:flutter/material.dart';
import 'pantalla_album.dart'; // Importante: Esto conecta con el archivo del álbum

void main() {
  runApp(const RunesOfColiseum());
}

class RunesOfColiseum extends StatelessWidget {
  const RunesOfColiseum({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runes of the Coliseum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const Portada(),
    );
  }
}

class Portada extends StatelessWidget {
  const Portada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título principal
                const Text(
                  'RUNES OF THE COLISEUM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 60),

                // Botón al ÁLBUM con la lógica de navegación real
                _buildMenuButton(context, 'ÁLBUM', () {
                  // Esta línea es la que hace que el navegador cambie de pantalla
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaAlbum()),
                  );
                }),

                const SizedBox(height: 20),

                // Botón al MAZO (Aún sin función hasta que lo programemos)
                _buildMenuButton(context, 'MAZO', () {
                  print("Módulo del Mazo en desarrollo...");
                }),
              ],
            ),
          ),

          // Versión en la esquina inferior derecha
          const Positioned(
            bottom: 20,
            right: 25,
            child: Text(
              'V.0.1.',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para crear botones uniformes
  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 240,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white38, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}