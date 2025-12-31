import 'package:flutter/material.dart';
import 'arsenal.dart';

class PantallaAlbum extends StatefulWidget {
  const PantallaAlbum({super.key});
  @override
  State<PantallaAlbum> createState() => _PantallaAlbumState();
}

//CONFIGURACIÓN DE FILTRO GENERAL
class _PantallaAlbumState extends State<PantallaAlbum> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  List<int> _nivelesSeleccionados = []; 
  List<Color> _coloresSeleccionados = [];

  final List<int> niveles = List.generate(10, (index) => index + 1);
  final List<Color> coloresRunicos = [Colors.red, Colors.blue, Colors.white
  ];

  @override // FILTRADO DINÁMICO
  Widget build(BuildContext context) {
    final listaFiltrada = arsenalMaestro.where((h) {
      // Filtrado por nombre
      final coincideNombre = h.Name.toLowerCase().contains(_query.toLowerCase());
      // Filtrado por nivel
      final coincideNivel = _nivelesSeleccionados.isEmpty || _nivelesSeleccionados.contains(h.NV);
      // Filtrado por color
      final coincideColor = _coloresSeleccionados.isEmpty || _coloresSeleccionados.contains(h.Color_Marco);
      return coincideNombre && coincideNivel && coincideColor;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      // FILTROS RÚNICOS
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0D0D0D),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TITULO DE FILTROS RÚNICOS
            DrawerHeader(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF150D00)],
                ),
              ),
              child: Center(child: Text("FILTROS RÚNICOS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2))),
            ),
            // FILTRO POR NIVEL
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("NIVELES (1-10)", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  // BOTÓN TODOS: Ahora verifica si la LISTA de niveles está vacía
                  _buildFilterChip(
                    "TODOS", 
                    _nivelesSeleccionados.isEmpty, 
                    () => setState(() => _nivelesSeleccionados.clear())
                  ),
                  // MAPEO DE NIVELES: Ahora agrega o quita elementos de la lista
                  ...niveles.map((n) {
                    final estaSeleccionado = _nivelesSeleccionados.contains(n);
                    return _buildFilterChip(
                      "NV: $n", 
                      estaSeleccionado, 
                      () => setState(() {
                        if (estaSeleccionado) {
                          _nivelesSeleccionados.remove(n); // Lo quita si ya estaba
                        } else {
                          _nivelesSeleccionados.add(n);    // Lo añade si no estaba
                        }
                      }),
                    );
                  }),
                ],
              ),
            ),
            // FILTRO POR COLOR
            const Divider(color: Colors.white10, height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("BORDES ELEMENTALES", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  // BOTÓN TODOS (COLORES): Limpia la lista de colores seleccionados
                  _buildColorChip(
                    null, 
                    _coloresSeleccionados.isEmpty, 
                    () => setState(() => _coloresSeleccionados.clear())
                  ),
                  // MAPEO DE COLORES: Agrega o quita colores de la lista
                  ...coloresRunicos.map((c) {
                    final estaSeleccionado = _coloresSeleccionados.contains(c);
                    return _buildColorChip(
                      c, 
                      estaSeleccionado, 
                      () => setState(() {
                        if (estaSeleccionado) {
                          _coloresSeleccionados.remove(c); // Quita el color
                        } else {
                          _coloresSeleccionados.add(c);    // Añade el color
                        }
                      }),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      //BARRA DE BUSQUEDA POR NOMBRE
      appBar: AppBar(
        title: const Text("ÁLBUM RÚNICO", style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          Builder(builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.amber),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          )),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Escribe el nombre de la carta...",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.amber, size: 20),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      //VISTA PREVIA DEL ALBUM EN GENERAL
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12
        ),
        itemCount: listaFiltrada.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _verDetalle(context, listaFiltrada[index]),
          child: _CartaUltraCompacta(habilidad: listaFiltrada[index]),
        ),
      ),
    );
  }

  // VISTA PREVIA INDIVIDUAL O EN DETALLE
  void _verDetalle(BuildContext context, Habilidad hab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85, //PENDIENTE PARA PROBAR ALGO ACÁ
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),
              Center(
                child: Stack(
                  children: [
                    // 1. LA CARTA BASE (Tu código original)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: (MediaQuery.of(context).size.width * 0.75) / 0.8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: hab.Color_Marco, width: 3), 
                        boxShadow: [
                          BoxShadow(
                        color: hab.Color_Marco.withOpacity(0.4), 
                        blurRadius: 15, 
                        spreadRadius: 2
                          )
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.shield, size: 100, color: hab.Color_Marco.withOpacity(0.5))
                      ),
                    ),
                    // 2. LA ETIQUETA DE ROL (Lo que agregamos)
                    Positioned(
                      // Usamos .clamp para que el margen nunca sea menor a 8 ni mayor a 20
                      top: (MediaQuery.of(context).size.width * 0.02).clamp(8.0, 20.0), 
                      right: (MediaQuery.of(context).size.width * 0.02).clamp(8.0, 20.0), 
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          // El padding horizontal no superará los 30 píxeles en PC
                          horizontal: (MediaQuery.of(context).size.width * 0.03).clamp(10.0, 30.0), 
                          // El padding vertical no superará los 10 píxeles
                          vertical: (MediaQuery.of(context).size.width * 0.01).clamp(4.0, 10.0),
                        ),
                        decoration: BoxDecoration(
                          color: hab.Color_Marco.withOpacity(0.8), 
                          borderRadius: BorderRadius.circular(4), // Radio fijo para mantener la forma
                          border: Border.all(color: Colors.white24, width: 0.5),
                        ),
                        child: Text(
                          hab.Color_Marco == Colors.red ? "OFENSIVA" : 
                          hab.Color_Marco == Colors.blue ? "DEFENSIVA" : "ESTADO",
                          style: TextStyle(
                            color: Colors.black, 
                            // El tamaño de letra no superará los 18 puntos en PC
                            fontSize: (MediaQuery.of(context).size.width * 0.03).clamp(10.0, 18.0), 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(hab.Name.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("NV: ${hab.NV}", style: const TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(color: Colors.white10, height: 40),
              const Text("CARACTERÍSTICAS", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 15),//AQUÍ TAMBIÉN
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statDetalle("PODER RÚNICO", hab.PDR), // CORRECCIÓN DE PDR
                    _statDetalle("ATAQUE", hab.ATQ),
                    _statDetalle("DEFENSA", hab.DEF),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "DESCRIPCIÓN DE HABILIDAD", 
                style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)
              ),
              const SizedBox(height: 15),
              Text(
                hab.Descripcion, 
                style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5, fontStyle: FontStyle.italic)
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
  //LOS TRES LADRILLOS EN VEZ DE MOSQUETEROS
// LADRILLO 1 (DETALLES)
  Widget _statDetalle(String etiqueta, dynamic valor) { // CAMBIO: 'dynamic' para evitar errores de datos
    return Column(
      mainAxisSize: MainAxisSize.min, // CAMBIO: Ocupa solo el espacio necesario
      children: [
        Text(etiqueta, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold) // TAMAÑO DE TEXTO
        ),
        const SizedBox(height: 2), // Un pequeño respiro entre etiqueta y valor
        Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold) // TAMAÑO DE VALOR
        ),
      ],
    );
  }
// LADRILLO 2 (BOTÓN)
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 10)),
      selected: isSelected, onSelected: (_) => onTap(),
      selectedColor: Colors.amber, backgroundColor: Colors.white10, showCheckmark: false,
    );
  }
// LADRILLO 3 (COLOR)
  Widget _buildColorChip(Color? color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35, 
        height: 35,
        decoration: BoxDecoration(
          // 1. Color de fondo más limpio para el botón "TODOS"
          color: color ?? Colors.white.withOpacity(0.1), 
          shape: BoxShape.circle,
          // 2. Borde Ámbar para ser coherente con los filtros de nivel
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white12, 
            width: isSelected ? 3 : 1,
          ),
        ),
        // 3. Cambiamos el icono de "Prohibido" por uno de "Filtros" o "Brillo"
        child: color == null 
            ? Icon(
                Icons.auto_awesome, 
                size: 16, 
                color: isSelected ? Colors.amber : Colors.white38
              ) 
            : null,
      ),
    );
  }
}

// ESTE ES EL MOLDE ORIGINAL DEL APK - MOLDE DE CARTA
class _CartaUltraCompacta extends StatelessWidget {
  final Habilidad habilidad;
  const _CartaUltraCompacta({required this.habilidad});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double anchoCarta = constraints.maxWidth;
      double fSize = anchoCarta * 0.05; // Escala exacta del APK
      double grosorBorde = anchoCarta * 0.02; 
      double intensidadBrillo = anchoCarta * 0.08; 

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          border: Border.all(color: habilidad.Color_Marco, width: grosorBorde),
          boxShadow: [
            BoxShadow(color: habilidad.Color_Marco.withOpacity(0.4), blurRadius: intensidadBrillo, spreadRadius: 1),
          ],
        ),
        child: Column(children: [
          Container(
            height: constraints.maxHeight * 0.07,
            width: double.infinity,
            color: Colors.black45,
            alignment: Alignment.center,
            child: FittedBox(child: Text(habilidad.Name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: fSize, color: Colors.white))),
          ),
          const Expanded(child: Center(child: Icon(Icons.shield, color: Colors.white10, size: 30))),
          Container(
            height: constraints.maxHeight * 0.13,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.white10))),
                  child: Padding( // MARGEN DE NV
                    padding: EdgeInsets.all(anchoCarta * 0.03), // QUE TAN GRANDE ES EL MARGEN
                    child: FittedBox(
                      fit: BoxFit.contain, 
                      child: Text(
                        "NV:${habilidad.NV}", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      )
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat("PDR", habilidad.PDR, fSize),
                    _miniStat("ATQ", habilidad.ATQ, fSize),
                    _miniStat("DEF", habilidad.DEF, fSize),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      );
    });
  }

  Widget _miniStat(String label, int val, double size) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(label, style: TextStyle(fontSize: size * 0.7, color: Colors.white38, fontWeight: FontWeight.bold)),
      Text("$val", style: TextStyle(fontSize: size * 0.9, fontWeight: FontWeight.bold, color: Colors.white)), // Dato en Blanco Puro
    ],
  );
}