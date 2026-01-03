import 'package:flutter/material.dart';
import 'arsenal.dart';

class PantallaAlbum extends StatefulWidget {
  final bool esModoSeleccion;
  final List<int> cartasOmitidas;
  const PantallaAlbum({super.key, this.esModoSeleccion = false, this.cartasOmitidas = const []});

  @override
  State<PantallaAlbum> createState() => _PantallaAlbumState();
}

class _PantallaAlbumState extends State<PantallaAlbum> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  List<int> _nivelesSeleccionados = [];
  List<Color> _coloresSeleccionados = [];

  final List<int> niveles = List.generate(10, (index) => index + 1);
  final List<Color> coloresRunicos = [Colors.red, Colors.blue, Colors.white];

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = arsenalMaestro.where((h) {
      final coincideNombre = h.Name.toLowerCase().contains(_query.toLowerCase());
      final coincideNivel = _nivelesSeleccionados.isEmpty || _nivelesSeleccionados.contains(h.NV);
      final coincideColor = _coloresSeleccionados.isEmpty || _coloresSeleccionados.contains(h.Color_Marco);
      final noEstaRepetida = !widget.cartasOmitidas.contains(h.ID);
      return coincideNombre && coincideNivel && coincideColor && noEstaRepetida;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0D0D0D),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF150D00)],
                ),
              ),
              child: const Center(
                child: Text(
                  "FILTROS RÚNICOS",
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text("NIVELES (1-10)", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2.5,
                        children: [
                          _buildFilterChip("TODOS", _nivelesSeleccionados.isEmpty, () => setState(() => _nivelesSeleccionados.clear())),
                          ...niveles.map((n) {
                            final estaSeleccionado = _nivelesSeleccionados.contains(n);
                            return _buildFilterChip("NV: $n", estaSeleccionado, () => setState(() {
                                  if (estaSeleccionado) {
                                    _nivelesSeleccionados.remove(n);
                                  } else {
                                    _nivelesSeleccionados.add(n);
                                  }
                                }));
                          }),
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
                        runSpacing: 12,
                        children: [
                          _buildColorChip(null, _coloresSeleccionados.isEmpty, () => setState(() => _coloresSeleccionados.clear())),
                          ...coloresRunicos.map((c) {
                            final estaSeleccionado = _coloresSeleccionados.contains(c);
                            return _buildColorChip(c, estaSeleccionado, () => setState(() {
                                  if (estaSeleccionado) {
                                    _coloresSeleccionados.remove(c);
                                  } else {
                                    _coloresSeleccionados.add(c);
                                  }
                                }));
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("ÁLBUM RÚNICO", style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.amber),
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
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: listaFiltrada.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (widget.esModoSeleccion) {
              _confirmarSeleccion(context, listaFiltrada[index]);
            } else {
              _verDetalle(context, listaFiltrada[index]);
            }
          },
          child: CartaResumen(habilidad: listaFiltrada[index]), // ← Usa el widget de arsenal.dart
        ),
      ),
    );
  }

  void _verDetalle(BuildContext context, Habilidad hab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final esHorizontal = orientation == Orientation.landscape;
            final size = MediaQuery.of(context).size;

            return Container(
              height: esHorizontal ? size.height * 0.92 : size.height * 0.85,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  Expanded(
                    child: CartaDetalle(habilidad: hab, esHorizontal: esHorizontal), // ← Usa el widget de arsenal.dart
                  ),
                ],
              ),
            );
          },
        );
      },
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
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color ?? Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white12,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: color == null
            ? Icon(Icons.auto_awesome, size: 16, color: isSelected ? Colors.amber : Colors.white38)
            : null,
      ),
    );
  }

  void _confirmarSeleccion(BuildContext context, Habilidad carta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0D),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: carta.Color_Marco, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "¿ASIGNAR CARTA?",
          style: TextStyle(color: carta.Color_Marco, fontSize: 14, letterSpacing: 2),
        ),
        content: Text(
          "¿Deseas agregar ${carta.Name.toUpperCase()} a este espacio del mazo?",
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.white24)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, carta);
            },
            child: Text("ACEPTAR", style: TextStyle(color: carta.Color_Marco, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}