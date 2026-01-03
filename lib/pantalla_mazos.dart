import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'arsenal.dart';
import 'pantalla_album.dart';

class PantallaMazos extends StatefulWidget {
  const PantallaMazos({super.key});
  @override
  State<PantallaMazos> createState() => _PantallaMazosState();
}

class _PantallaMazosState extends State<PantallaMazos> {
  static List<List<Habilidad?>> misMazos = List.generate(
    6,
    (_) => List.filled(10, null),
  );

  @override
  void initState() {
    super.initState();
    _cargarMazosDeMemoria();
  }

  Future<void> _cargarMazosDeMemoria() async {
  final prefs = await SharedPreferences.getInstance();

  // Reiniciar todos los mazos a 10 slots vacíos
  for (int i = 0; i < 6; i++) {
    misMazos[i] = List.filled(10, null);
  }

  // Cargar desde SharedPreferences
  for (int i = 0; i < 6; i++) {
    List<String>? ids = prefs.getStringList('mazo_runico_$i');
    if (ids != null) {
      for (int j = 0; j < 10 && j < ids.length; j++) {
        if (ids[j] != "vacio") {
          try {
            int idNumerico = int.parse(ids[j]);
            Habilidad? encontrada;
            // Buscar manualmente en el arsenal
            for (var h in arsenalMaestro) {
              if (h.ID == idNumerico) {
                encontrada = h;
                break;
              }
            }
            misMazos[i][j] = encontrada;
          } catch (e) {
            misMazos[i][j] = null;
          }
        }
      }
    }
  }

  // Actualizar la UI solo si el widget aún está activo
  if (mounted) {
    setState(() {});
  }
}

Future<void> _guardarMazosEnMemoria() async {
  final prefs = await SharedPreferences.getInstance();
  for (int i = 0; i < 6; i++) {
    List<String> ids = misMazos[i]
        .map((h) => h?.ID.toString() ?? "vacio")
        .toList();
    // Asegurar que siempre haya 10 elementos
    while (ids.length < 10) ids.add("vacio");
    await prefs.setStringList('mazo_runico_$i', ids);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("TUS MAZOS", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6,
        itemBuilder: (context, index) => _buildMazoEntry(index),
      ),
    );
  }

  Widget _buildMazoEntry(int index) {
    final mazoLleno = misMazos[index].whereType<Habilidad>().toList();
    Color colorBorde = _calcularColorMazo(mazoLleno);
    bool esHorizontal = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetalleMazo(
            numeroMazo: index + 1,
            cartas: misMazos[index],
            onChanged: () {
              setState(() {});
              unawaited(_guardarMazosEnMemoria());
            },
          )),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: colorBorde, width: 2),
          color: Colors.white.withOpacity(0.05),
          boxShadow: [BoxShadow(color: colorBorde.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: esHorizontal ? 2 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("MAZO ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: esHorizontal ? 14 : 18)),
                  const SizedBox(height: 5),
                  Text("${mazoLleno.length} / 10 CARTAS", style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: esHorizontal ? 8 : 7,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: esHorizontal ? 10 : 5,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: esHorizontal ? 0.75 : 0.8,
                ),
                itemCount: 10,
                itemBuilder: (context, i) {
                  final c = misMazos[index][i];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      image: c != null ? DecorationImage(image: AssetImage(c.Image), fit: BoxFit.cover) : null,
                      border: Border.all(color: c == null ? Colors.white12 : c.Color_Marco, width: 1.5),
                      boxShadow: [
                        if (c != null) BoxShadow(
                          color: c.Color_Marco.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _calcularColorMazo(List<Habilidad> mazo) {
    if (mazo.isEmpty) return Colors.white10;
    int atk = mazo.where((h) => h.Rol == "ATK").length;
    int dfs = mazo.where((h) => h.Rol == "DFS").length;
    int std = mazo.where((h) => h.Rol == "STD").length;

    const Color verdeEquilibrio = Color(0xFF1DE9B6);
    const Color cyanPalido = Color(0xFFB2EBF2);
    const Color rosaPalido = Color(0xFFFFD1DC);
    const Color moradoMate = Color(0xFF673AB7);

    if (atk >= 5 && atk > dfs && atk > std) return Colors.redAccent;
    if (dfs >= 5 && dfs > atk && dfs > std) return Colors.blueAccent;
    if (std >= 5 && std > atk && std > dfs) return Colors.white;

    List<int> valores = [atk, dfs, std]..sort();
    if (atk > 0 && dfs > 0 && std > 0 && (valores[2] - valores[0] <= 1)) return verdeEquilibrio;

    if (atk == dfs && atk >= 4) return moradoMate;
    if (atk == std && atk >= 4) return rosaPalido;
    if (dfs == std && dfs >= 4) return cyanPalido;

    if (atk > 0 && dfs > 0) return moradoMate;
    if (atk > 0 && std > 0) return rosaPalido;
    if (dfs > 0 && std > 0) return cyanPalido;

    if (atk > dfs && atk > std) return Colors.redAccent;
    if (dfs > atk && dfs > std) return Colors.blueAccent;
    return Colors.white;
  }
}

class DetalleMazo extends StatefulWidget {
  final int numeroMazo;
  final List<Habilidad?> cartas;
  final VoidCallback onChanged;
  const DetalleMazo({super.key, required this.numeroMazo, required this.cartas, required this.onChanged});

  @override
  State<DetalleMazo> createState() => _DetalleMazoState();
}

class _DetalleMazoState extends State<DetalleMazo> {
  bool _mostrarDetalles = false;

  void _gestionarSlot(int index, Habilidad? cartaActual) {
    if (cartaActual == null) {
      _abrirSelector(index);
    } else {
      _mostrarOpciones(index, cartaActual);
    }
  }

  void _generarMazoAleatorio() {
    final random = Random();
    List<Habilidad> copiaArsenal = List.from(arsenalMaestro);
    copiaArsenal.shuffle(random);
    setState(() {
      for (int i = 0; i < 10; i++) {
        widget.cartas[i] = copiaArsenal[i];
      }
    });
    widget.onChanged();
  }

  Future<void> _abrirSelector(int index) async {
    final idsActuales = widget.cartas.where((c) => c != null).map((c) => c!.ID).toList();
    final Habilidad? seleccion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PantallaAlbum(esModoSeleccion: true, cartasOmitidas: idsActuales)),
    );
    if (seleccion != null) {
      setState(() => widget.cartas[index] = seleccion);
      widget.onChanged();
    }
  }

  void _mostrarOpciones(int index, Habilidad carta) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0D0D0D),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(carta.Name.toUpperCase(), style: TextStyle(color: carta.Color_Marco, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye, color: Colors.amber),
            title: const Text("VER DETALLES", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _abrirVistaDetalle(carta);
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.blue),
            title: const Text("CAMBIAR CARTA", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _abrirSelector(index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text("ELIMINAR DEL MAZO", style: TextStyle(color: Colors.white)),
            onTap: () {
              setState(() => widget.cartas[index] = null);
              widget.onChanged();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  void _abrirVistaDetalle(Habilidad hab) {
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: CartaDetalle(habilidad: hab, esHorizontal: esHorizontal),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  Widget _miniChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.5)), borderRadius: BorderRadius.circular(5)),
      child: Text("$label: $value", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mazoValido = widget.cartas.whereType<Habilidad>().toList();
    int total = mazoValido.length;
    bool esHorizontal = MediaQuery.of(context).orientation == Orientation.landscape;
    int columnas = esHorizontal ? 5 : 2; // ← 2 en vertical, 5 en horizontal

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("EDICIÓN MAZO ${widget.numeroMazo}", style: const TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: () {
              setState(() {
                for (int i = 0; i < 10; i++) widget.cartas[i] = null;
              });
              widget.onChanged();
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino, color: Colors.amber),
            onPressed: _generarMazoAleatorio,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                final carta = widget.cartas[index];
                return GestureDetector(
                  onTap: () => _gestionarSlot(index, carta),
                  child: carta == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10, width: 2),
                            color: Colors.white.withOpacity(0.02),
                          ),
                          child: const Icon(Icons.add_circle_outline, color: Colors.white24, size: 50),
                        )
                      : CartaResumen(habilidad: carta), // ← Usa el widget centralizado
                );
              },
            ),
          ),
          // BOTÓN DETALLES + MENÚ DESPLEGABLE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 2)),
            ),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _mostrarDetalles = !_mostrarDetalles),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.amber, width: 1),
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("DETALLES", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      Icon(
                        _mostrarDetalles ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
                if (_mostrarDetalles) ...[
                  const SizedBox(height: 10),
                  ..._buildAnalisisDetalles(mazoValido, total),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnalisisDetalles(List<Habilidad> mazo, int total) {
    double atkP = total == 0 ? 0 : (mazo.where((h) => h.Rol == "ATK").length / total) * 100;
    double dfsP = total == 0 ? 0 : (mazo.where((h) => h.Rol == "DFS").length / total) * 100;
    double stdP = total == 0 ? 0 : (mazo.where((h) => h.Rol == "STD").length / total) * 100;

    return [
      _filaAnalisis("CARTAS OFENSIVAS", atkP, Colors.red),
      _filaAnalisis("CARTAS DEFENSIVAS", dfsP, Colors.blue),
      _filaAnalisis("CARTAS DE ESTADO", stdP, Colors.white),
      const SizedBox(height: 10),
      Text("TOTAL: $total / 10", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 3)),
    ];
  }

  Widget _filaAnalisis(String nombre, double porc, Color col) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nombre, style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          Text("${porc.toStringAsFixed(0)}%", style: TextStyle(color: col, fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}