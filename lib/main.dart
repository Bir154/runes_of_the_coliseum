import 'package:flutter/material.dart';
import 'pantalla_album.dart'; 
import 'pantalla_mazos.dart'; // 1. YA ESTÁ DESCOMENTADO PARA CONECTAR EL ARCHIVO

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

                // Botón al ÁLBUM
                _buildMenuButton(context, 'ÁLBUM', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaAlbum()),
                  );
                }),

                const SizedBox(height: 20),

                // Botón al MAZO (AHORA CONECTADO A PANTALLAMAZOS)
                _buildMenuButton(context, 'MAZO', () {
                  // 2. CAMBIADO EL PRINT POR LA NAVEGACIÓN REAL
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaMazos()),
                  );
                }),

                const SizedBox(height: 20),

                // Botón COMBATE (Nuevo)
                _buildMenuButton(context, 'COMBATE', () {
                  print("Iniciando modo combate...");
                }, esCombate: true),
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

  // Función para crear botones uniformes con opción de resaltar Combate
  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed, {bool esCombate = false}) {
    return SizedBox(
      width: 240,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: esCombate ? Colors.redAccent : Colors.white38, 
            width: 2
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: esCombate ? Colors.redAccent.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 3,
            color: esCombate ? Colors.redAccent : Colors.white,
            fontWeight: esCombate ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}