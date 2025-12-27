import 'package:flutter/material.dart';
import 'arsenal.dart';

class PantallaAlbum extends StatefulWidget {
  const PantallaAlbum({super.key});
  @override
  State<PantallaAlbum> createState() => _PantallaAlbumState();
}

class _PantallaAlbumState extends State<PantallaAlbum> {
  final TextEditingController _searchController = TextEditingController();
  String _query = ""; 
  int? _filtroNivel;
  Color? _filtroColor;

  // Rango oficial de niveles (1 al 10) [cite: 2025-11-10]
  final List<int> niveles = List.generate(10, (index) => index + 1);
  
  // Colores base actuales. Puedes agregar más aquí fácilmente en el futuro [cite: 2025-11-10]
  final List<Color> coloresRunicos = [
    Colors.red, 
    Colors.green, 
    Colors.purple, 
    Colors.blue, 
    Colors.yellow,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    // FILTRADO DINÁMICO TRIPLE
    final listaFiltrada = arsenalMaestro.where((h) {
      final coincideNombre = h.nombre.toLowerCase().contains(_query.toLowerCase());
      final coincideNivel = _filtroNivel == null || h.nv == _filtroNivel;
      final coincideColor = _filtroColor == null || h.colorMarco == _filtroColor;
      return coincideNombre && coincideNivel && coincideColor;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      // PANEL LATERAL DE FILTROS (HAMBURGUESA) [cite: 2025-11-10]
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0D0D0D),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(child: Text("FILTROS RÚNICOS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2))),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("NIVELES (1-10)", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip("TODOS", _filtroNivel == null, () => setState(() => _filtroNivel = null)),
                  ...niveles.map((n) => _buildFilterChip("NV: $n", _filtroNivel == n, () => setState(() => _filtroNivel = n))),
                ],
              ),
            ),
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
                  _buildColorChip(null, _filtroColor == null, () => setState(() => _filtroColor = null)),
                  ...coloresRunicos.map((c) => _buildColorChip(c, _filtroColor == c, () => setState(() => _filtroColor = c))),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("ÁLBUM RÚNICO", style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.amber), // Botón Hamburguesa [cite: 2025-11-10]
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
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
      body: listaFiltrada.isEmpty 
        ? const Center(child: Text("No hay cartas con estos filtros", style: TextStyle(color: Colors.white38)))
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              childAspectRatio: 0.8, 
              crossAxisSpacing: 12, 
              mainAxisSpacing: 12
            ),
            itemCount: listaFiltrada.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _verDetalle(context, listaFiltrada[index]),
              child: _CartaUltraCompacta(habilidad: listaFiltrada[index]),
            ),
          ),
    );
  }

  void _verDetalle(BuildContext context, Habilidad hab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),
              
              // IMAGEN CON BORDE Y BRILLO ESCALADOS [cite: 2025-11-10]
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: (MediaQuery.of(context).size.width * 0.75) / 0.8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: hab.colorMarco, width: MediaQuery.of(context).size.width * 0.006), 
                    boxShadow: [
                      BoxShadow(color: hab.colorMarco.withOpacity(0.4), blurRadius: 15, spreadRadius: 2),
                    ],
                  ),
                  child: Center(child: Icon(Icons.shield, size: 100, color: hab.colorMarco.withOpacity(0.5))),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(hab.nombre.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("NV: ${hab.nv}", style: const TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(color: Colors.white10, height: 40),

              // NUEVA SECCIÓN DE CARACTERÍSTICAS [cite: 2025-11-10]
              const Text("CARACTERÍSTICAS", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statDetalle("PODER", hab.pdr),
                    _statDetalle("ATAQUE", hab.atq),
                    _statDetalle("DEFENSA", hab.def),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              const Text("DEFINICIÓN", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Text(hab.descripcion, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70)),
              
              const SizedBox(height: 35),

              // TABLA DE ATRIBUTOS TÉCNICOS RESTAURADA [cite: 2025-11-10]
              const Text("ATRIBUTOS TÉCNICOS", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 15),
              Table(
                border: TableBorder.all(color: Colors.white10),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white10),
                    children: const [
                      Padding(padding: EdgeInsets.all(12), child: Text("#", style: TextStyle(fontSize: 10))),
                      Padding(padding: EdgeInsets.all(12), child: Text("FORTALEZAS", style: TextStyle(fontSize: 10))),
                      Padding(padding: EdgeInsets.all(12), child: Text("DEBILIDADES", style: TextStyle(fontSize: 10))),
                    ],
                  ),
                  for (int i = 0; i < 3; i++)
                    TableRow(children: [
                      Padding(padding: const EdgeInsets.all(12), child: Text("${i + 1}", style: const TextStyle(color: Colors.white38))),
                      Padding(padding: const EdgeInsets.all(12), child: Text(hab.fortalezas[i], style: const TextStyle(fontSize: 12))),
                      Padding(padding: const EdgeInsets.all(12), child: Text(hab.debilidades[i], style: const TextStyle(fontSize: 12))),
                    ]),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statDetalle(String etiqueta, int valor) {
    return Column(
      children: [
        Text(etiqueta, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 10)),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.amber,
      backgroundColor: Colors.white10,
      showCheckmark: false,
    );
  }

  Widget _buildColorChip(Color? color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35, height: 35,
        decoration: BoxDecoration(
          color: color ?? Colors.grey.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
        ),
        child: color == null ? const Icon(Icons.block, size: 15, color: Colors.white54) : null,
      ),
    );
  }
}

class _CartaUltraCompacta extends StatelessWidget {
  final Habilidad habilidad;
  const _CartaUltraCompacta({required this.habilidad});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double anchoCarta = constraints.maxWidth;
      double fSize = anchoCarta * 0.05;
      double grosorBorde = anchoCarta * 0.02; 
      double intensidadBrillo = anchoCarta * 0.08; 

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          border: Border.all(color: habilidad.colorMarco, width: grosorBorde),
          boxShadow: [
            BoxShadow(color: habilidad.colorMarco.withOpacity(0.4), blurRadius: intensidadBrillo, spreadRadius: 1),
          ],
        ),
        child: Column(children: [
          Container(
            height: constraints.maxHeight * 0.07,
            width: double.infinity,
            color: Colors.black45,
            alignment: Alignment.center,
            child: FittedBox(child: Text(habilidad.nombre.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: fSize))),
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
                  child: FittedBox(fit: BoxFit.contain, child: Text("NV:${habilidad.nv}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                ),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat("PDR", habilidad.pdr, fSize),
                    _miniStat("ATQ", habilidad.atq, fSize),
                    _miniStat("DEF", habilidad.def, fSize),
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
      Text(label, style: TextStyle(fontSize: size * 0.5, color: Colors.white38)),
      Text("$val", style: TextStyle(fontSize: size * 0.8, fontWeight: FontWeight.bold)),
    ],
  );
}