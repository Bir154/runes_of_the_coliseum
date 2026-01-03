import 'package:flutter/material.dart';

class Habilidad {
  final int ID;
  final String Name;
  final String Descripcion;
  final int NV;
  final int PDR; // Poder de Runa
  final int ATQ;
  final int DEF;
  final Color Color_Marco;
  final String Image;
  final String Rol;

  Habilidad({
    required this.ID, required this.Name, required this.Descripcion, required this.NV, required this.PDR, required this.ATQ,
    required this.DEF, required this.Color_Marco, required this.Image, required this.Rol,
  });
}

// ====== WIDGET: CARTA EN LISTA (RESUMEN) ======
class CartaResumen extends StatelessWidget {
  final Habilidad habilidad;
  const CartaResumen({super.key, required this.habilidad});

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
          border: Border.all(color: habilidad.Color_Marco, width: grosorBorde),
          boxShadow: [BoxShadow(color: habilidad.Color_Marco.withOpacity(0.4), blurRadius: intensidadBrillo, spreadRadius: 1)],
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
                  child: Padding(
                    padding: EdgeInsets.all(anchoCarta * 0.03),
                    child: FittedBox(fit: BoxFit.contain, child: Text("NV:${habilidad.NV}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
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
      Text("$val", style: TextStyle(fontSize: size * 0.9, fontWeight: FontWeight.bold, color: Colors.white)),
    ],
  );
}

// ====== WIDGET: CARTA EN MODO DETALLE (MODAL) ======
// ====== WIDGET: CARTA EN MODO DETALLE (MODAL) ======
class CartaDetalle extends StatelessWidget {
  final Habilidad habilidad;
  final bool esHorizontal;

  const CartaDetalle({
    super.key,
    required this.habilidad,
    required this.esHorizontal,
  });

  // Mapeo de rol técnico a nombre legible
  String _rolLegible(String rol) {
    switch (rol) {
      case "ATK": return "OFENSIVA";
      case "DFS": return "DEFENSIVA";
      case "STD": return "ESTADO";
      default: return "DESCONOCIDO";
    }
  }

  @override
  Widget build(BuildContext context) {
    return esHorizontal
        ? _buildHorizontal(context)
        : _buildVertical(context);
  }

  Widget _buildVertical(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildImagen(context)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                habilidad.Name.toUpperCase(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "NV: ${habilidad.NV}",
                style: const TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const Divider(color: Colors.white10, height: 40),
          const Text("CARACTERÍSTICAS", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statDetalle("PODER RÚNICO", habilidad.PDR),
                _statDetalle("ATAQUE", habilidad.ATQ),
                _statDetalle("DEFENSA", habilidad.DEF),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("DESCRIPCIÓN", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            habilidad.Descripcion,
            style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: _buildImagen(context),
        ),
        const SizedBox(width: 25),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("STATS", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              _statDetalleVertical("PDR", habilidad.PDR),
              _statDetalleVertical("ATQ", habilidad.ATQ),
              _statDetalleVertical("DEF", habilidad.DEF),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      habilidad.Name.toUpperCase(),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    "NV: ${habilidad.NV}",
                    style: const TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              const Divider(color: Colors.white10, height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DESCRIPCIÓN", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        habilidad.Descripcion,
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _rolColor(String rol) {
    switch (rol) {
      case "ATK": return Colors.red;
      case "DFS": return Colors.blue;
      case "STD": return Colors.white;
      default: return Colors.grey;
    }
  }

    Widget _buildImagen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: habilidad.Color_Marco, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: habilidad.Color_Marco.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.shield,
                  size: 80,
                  color: habilidad.Color_Marco.withOpacity(0.3),
                ),
              ),
            ),
          ),
          // Etiqueta de rol en la esquina superior derecha
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _rolColor(habilidad.Rol).withOpacity(0.85),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                _rolLegible(habilidad.Rol),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDetalleVertical(String etiqueta, dynamic valor) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(etiqueta, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statDetalle(String etiqueta, dynamic valor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(etiqueta, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

final List<Habilidad> arsenalMaestro = [
  Habilidad(ID: 1, Name: "PUÑETAZO DIRECTO", Descripcion: "Golpe frontal rápido y preciso. Si el PDR del enemigo es mayor, esta carta multiplica su ATQ x2, asegurando que el impacto sea certero al enfrentarse a cartas ofensivas más veloces.", NV: 1, PDR: 50, ATQ: 50, DEF: 0, Color_Marco: Colors.red, Image: "carta_0001.png", Rol: "ATK"),
  Habilidad(ID: 2, Name: "CORTES RÁPIDOS", Descripcion: "Técnica de combate ágil. Su alto PDR permite que la acción se ejecute primero, siendo ideal para intentar reducir la salud del oponente antes de que este logre activar sus cartas defensivas.", NV: 1, PDR: 70, ATQ: 30, DEF: 0, Color_Marco: Colors.red, Image: "carta_0002.png", Rol: "ATK"),
  Habilidad(ID: 3, Name: "LANZA", Descripcion: "Arma de largo alcance que mantiene la distancia. Esta carta permite atacar con su ATQ mientras otorga una ligera protección con su DEF, compensando su bajo PDR gracias a su longitud.", NV: 1, PDR: 20, ATQ: 60, DEF: 20, Color_Marco: Colors.red, Image: "carta_0003.png", Rol: "ATK"),
  Habilidad(ID: 4, Name: "ARCO Y FLECHA", Descripcion: "Arma de proyectiles para ataques a distancia. Si esta carta pierde el duelo contra cartas ofensivas, lanza un contraataque con una segunda flecha que inflige un 50% de su ATQ original directamente al oponente.", NV: 1, PDR: 60, ATQ: 40, DEF: 0, Color_Marco: Colors.red, Image: "carta_0004.png", Rol: "ATK"),
  Habilidad(ID: 5, Name: "ROCA", Descripcion: "Piedra común que se lanza para causar daño al oponente. El impacto total se calcula comparando su valor de ATQ contra la DEF que presente el enemigo en sus cartas defensivas activas.", NV: 1, PDR: 20, ATQ: 50, DEF: 30, Color_Marco: Colors.red, Image: "carta_0005.png", Rol: "ATK"),
  Habilidad(ID: 6, Name: "RUNA DE PIEDRA", Descripcion: "Antiguo símbolo grabado que endurece la piel del usuario. Al activarse, su DEF se utiliza íntegramente para bloquear ataques, reduciendo el impacto recibido por el uso de cartas ofensivas enemigas.", NV: 1, PDR: 20, ATQ: 0, DEF: 80, Color_Marco: Colors.blue, Image: "carta_0006.png", Rol: "DFS"),
  Habilidad(ID: 7, Name: "VELO DE NIEBLA", Descripcion: "Hechizo elemental que crea una cortina blanca. Si el PDR del usuario es superior al del rival, esta carta reduce un 25% extra del daño total del enemigo además de usar su DEF.", NV: 1, PDR: 60, ATQ: 0, DEF: 40, Color_Marco: Colors.blue, Image: "carta_0007.png", Rol: "DFS"),
  Habilidad(ID: 8, Name: "ESCUDO DE MADERA", Descripcion: "Protección de tablas que ayuda a bloquear ataques. Su valor de DEF se resta directamente del ataque enemigo para mitigar el daño recibido, aunque es poco efectiva contra cartas de niveles superiores.", NV: 1, PDR: 30, ATQ: 0, DEF: 70, Color_Marco: Colors.blue, Image: "carta_0008.png", Rol: "DFS"),
  Habilidad(ID: 9, Name: "BURBUJAS DE AGUA", Descripcion: "Pequeñas esferas de agua que amortiguan impactos. Debido a su cantidad, esta carta puede utilizar su DEF para bloquear un contraataque enemigo en el mismo turno, funcionando como una de las cartas defensivas más versátiles del inicio.", NV: 1, PDR: 40, ATQ: 10, DEF: 50, Color_Marco: Colors.blue, Image: "carta_0009.png", Rol: "DFS"),
  Habilidad(ID: 10, Name: "PARACAÍDAS", Descripcion: "Equipo de descenso que protege contra impactos por caída. Su función otorga una DEF diseñada para evitar daños por efectos de tipo Impacto o ataques aéreos, si esta carta pierde, reduce el daño restante del oponente en un 50%.", NV: 1, PDR: 10, ATQ: 0, DEF: 90, Color_Marco: Colors.blue, Image: "carta_0010.png", Rol: "DFS"),
  Habilidad(ID: 11, Name: "CENTELLA LUMINOSA", Descripcion: "Destello mágico que busca desorientar. Su función principal es asegurar una buena iniciativa, aumentando el PDR del usuario en un 50% para el inicio de la siguiente ronda de combate.", NV: 1, PDR: 90, ATQ: 0, DEF: 10, Color_Marco: Colors.white, Image: "carta_0011.png", Rol: "STD"),
  Habilidad(ID: 12, Name: "RUNA DE VIGOR", Descripcion: "Marca mística que canaliza energía vital. Al usarse, restaura los PS del jugador en base al valor de DEF actual, permitiendo resistir más en el duelo.", NV: 1, PDR: 40, ATQ: 0, DEF: 60, Color_Marco: Colors.white, Image: "carta_0012.png", Rol: "STD"),
  Habilidad(ID: 13, Name: "FRASCO DE ACEITE", Descripcion: "Recipiente con líquido resbaladizo que entorpece al rival. Esta carta de estado reduce un 25% el PDR de la siguiente carta del oponente para el próximo turno, facilitando que el usuario gane la prioridad de movimiento.", NV: 1, PDR: 80, ATQ: 20, DEF: 0, Color_Marco: Colors.white, Image: "carta_0013.png", Rol: "STD"),
  Habilidad(ID: 14, Name: "GRUÑIDO", Descripcion: "Sonido de amenaza que busca intimidar al rival. Esta acción causa un daño mínimo basado en su ATQ, pero su función principal es aumentar los puntos de PDR del usuario para el próximo turno un 25%.", NV: 1, PDR: 60, ATQ: 30, DEF: 10, Color_Marco: Colors.white, Image: "carta_0014.png", Rol: "STD"),
  Habilidad(ID: 15, Name: "LUPA", Descripcion: "Herramienta de observación para analizar al rival. Esta carta de estado otorga un aumento del 25% al PDR del usuario durante el próximo turno, permitiendo que su siguiente acción tenga mayor prioridad de movimiento.", NV: 1, PDR: 80, ATQ: 0, DEF: 20, Color_Marco: Colors.white, Image: "carta_0015.png", Rol: "STD"),
  Habilidad(ID: 16, Name: "TAJO CRUZADO", Descripcion: "Técnica de combate que ejecuta dos cortes simultáneos. Si esta carta ofensiva gana el duelo y genera daño restante, dicho valor se multiplica x2, permitiendo que el impacto final hacia los PS enemigos sea mucho más devastador.", NV: 2, PDR: 80, ATQ: 100, DEF: 20, Color_Marco: Colors.red, Image: "carta_0016.png", Rol: "ATK"),
  Habilidad(ID: 17, Name: "GRANADA", Descripcion: "Explosivo manual de uso sencillo pero eficaz. Esta carta ofensiva causa un impacto cuya detonación permite ignorar el 25% de la DEF del oponente, facilitando que su ATQ genere un daño restante superior al enfrentar cartas defensivas.", NV: 2, PDR: 50, ATQ: 140, DEF: 10, Color_Marco: Colors.red, Image: "carta_0017.png", Rol: "ATK"),
  Habilidad(ID: 18, Name: "GIRO DE HACHA", Descripcion: "Ataque circular pesado que aprovecha el impulso del giro. Esta carta ofensiva sacrifica PDR para concentrar su fuerza en un ATQ masivo, buscando superar la DEF enemiga y maximizar el daño restante tras el impacto.", NV: 2, PDR: 40, ATQ: 140, DEF: 20, Color_Marco: Colors.red, Image: "carta_0018.png", Rol: "ATK"),
  Habilidad(ID: 19, Name: "ESTOCADA", Descripcion: "Movimiento de punta ejecutado con precisión quirúrgica. Esta carta ofensiva utiliza su elevado PDR para impactar antes de que el enemigo active su acción, permitiendo que el ATQ se aplique como daño restante si el oponente no posee una defensa prioritaria..", NV: 2, PDR: 140, ATQ: 60, DEF: 0, Color_Marco: Colors.red, Image: "carta_0019.png", Rol: "ATK"),
  Habilidad(ID: 20, Name: "FLECHA DE ÉTER", Descripcion: "Disparo de energía pura que atraviesa el campo. Al priorizar el PDR, esta carta ofensiva asegura que su ATQ alcance al objetivo antes de que el enemigo logre activar el efecto de sus cartas defensivas o de estado.", NV: 2, PDR: 120, ATQ: 80, DEF: 0, Color_Marco: Colors.red, Image: "carta_0020.png", Rol: "ATK"),
  Habilidad(ID: 21, Name: "ESCUDO TÉRMICO", Descripcion: "Barrera de metal caliente que protege al usuario. Esta carta defensiva utiliza su DEF para bloquear impactos y posee la función especial de reducir automáticamente un 25% el daño restante final causado por las cartas ofensivas enemigas.", NV: 2, PDR: 50, ATQ: 30, DEF: 120, Color_Marco: Colors.blue, Image: "carta_0021.png", Rol: "DFS"),
  Habilidad(ID: 22, Name: "POSTURA DE GUARDIA", Descripcion: "Maniobra defensiva para absorber impactos. Esta carta defensiva otorga una DEF elevada para reducir el daño restante de las cartas ofensivas enemigas y aumenta un 25% el PDR del usuario durante el próximo turno.", NV: 2, PDR: 40, ATQ: 10, DEF: 150, Color_Marco: Colors.blue, Image: "carta_0022.png", Rol: "DFS"),
  Habilidad(ID: 23, Name: "ESCUDO DE BRONCE", Descripcion: "Herramienta metálica reforzada para la protección estándar. Al activarse, su DEF se resta íntegramente del ATQ de las cartas ofensivas enemigas, siendo un recurso confiable para mitigar el daño restante durante los duelos de nivel medio.", NV: 2, PDR: 60, ATQ: 10, DEF: 130, Color_Marco: Colors.blue, Image: "carta_0023.png", Rol: "DFS"),
  Habilidad(ID: 24, Name: "BURBUJA DE MANÁ", Descripcion: "Escudo de energía mística protectora. Utiliza su DEF para absorber ataques, recuperando un 25% de PS en caso de ganar o reduciendo un 25% del daño restante en caso de perder.", NV: 2, PDR: 60, ATQ: 20, DEF: 120, Color_Marco: Colors.blue, Image: "carta_0024.png", Rol: "DFS"),
  Habilidad(ID: 25, Name: "OLAS DE RÍO", Descripcion: "Corriente de agua que empuja y desvía los ataques. Esta carta defensiva utiliza su DEF para mitigar impactos y, gracias a su fluidez, reduce un 25% el daño restante causado por el oponente durante el turno actual.", NV: 2, PDR: 80, ATQ: 40, DEF: 80, Color_Marco: Colors.blue, Image: "carta_0025.png", Rol: "DFS"),
  Habilidad(ID: 26, Name: "GRITO DE GUERRA", Descripcion: "Grito inspirador que altera el ritmo del combate. Esta carta de estado utiliza su elevado PDR para garantizar la iniciativa de movimiento y otorga un aumento del 50% al PDR del usuario durante el próximo turno.", NV: 2, PDR: 150, ATQ: 50, DEF: 0, Color_Marco: Colors.white, Image: "carta_0026.png", Rol: "STD"),
  Habilidad(ID: 27, Name: "AMULETO DE AGILIDAD", Descripcion: "Artefacto místico que aligera los movimientos del portador. Esta carta de estado otorga una ventaja táctica al aumentar en un 50% tanto el PDR como la DEF del usuario durante el próximo turno, reforzando la capacidad de respuesta y protección.", NV: 2, PDR: 100, ATQ: 0, DEF: 100, Color_Marco: Colors.white, Image: "carta_0027.png", Rol: "STD"),
  Habilidad(ID: 28, Name: "REGENERACIÓN LEVE", Descripcion: "Técnica de sanación que restaura vitalidad al usuario. Esta carta de estado utiliza su valor de DEF para recuperar una cantidad equivalente de PS durante el turno actual, ignorando cualquier interacción con el ATQ enemigo.", NV: 2, PDR: 80, ATQ: 0, DEF: 120, Color_Marco: Colors.white, Image: "carta_0028.png", Rol: "STD"),
  Habilidad(ID: 29, Name: "BOMBA DE HUMO", Descripcion: "Artefacto que libera una cortina densa para nublar la vista. Su función es anular el ATQ enemigo si el usuario posee un mayor PDR, obligando al rival a fallar su acción.", NV: 2, PDR: 150, ATQ: 0, DEF: 50, Color_Marco: Colors.white, Image: "carta_0029.png", Rol: "STD"),
  Habilidad(ID: 30, Name: "CARGA VITAL", Descripcion: "El usuario concentra su energía vital para sanar sus heridas. La cantidad de salud recuperada es exactamente igual al valor de DEF de la carta al momento de activarse.", NV: 2, PDR: 100, ATQ: 0, DEF: 100, Color_Marco: Colors.white, Image: "carta_0030.png", Rol: "STD"),
  Habilidad(ID: 31, Name: "BOLA DE FUEGO", Descripcion: "Esfera de fuego masiva que equilibra ofensiva y protección. Utiliza su ATQ para herir y su valor de DEF para chocar contra proyectiles enemigos, permitiendo un intercambio de golpes mucho más seguro.", NV: 3, PDR: 100, ATQ: 100, DEF: 100, Color_Marco: Colors.red, Image: "carta_0031.png", Rol: "ATK"),
  Habilidad(ID: 32, Name: "FILO ÍGNEO", Descripcion: "Espada envuelta en llamas constantes. Su función suma el valor de ATQ físico con un daño extra por quemadura que equivale al 25% de la potencia total de la carta.", NV: 3, PDR: 150, ATQ: 100, DEF: 50, Color_Marco: Colors.red, Image: "carta_0032.png", Rol: "ATK"),
  Habilidad(ID: 33, Name: "DAGA ASESINA", Descripcion: "Hoja pequeña, ligera y extremadamente veloz. Al no poseer puntos de DEF, utiliza todo su presupuesto para asegurar un PDR alto que permita golpear antes de que el rival reaccione.", NV: 3, PDR: 200, ATQ: 100, DEF: 0, Color_Marco: Colors.red, Image: "carta_0033.png", Rol: "ATK"),
  Habilidad(ID: 34, Name: "ESPADA GLADIADOR", Descripcion: "Arma de combate equilibrada y confiable. Utiliza su ATQ para presionar al oponente mientras mantiene una DEF básica para proteger al usuario durante el intercambio de golpes en el duelo.", NV: 3, PDR: 100, ATQ: 150, DEF: 50, Color_Marco: Colors.red, Image: "carta_0034.png", Rol: "ATK"),
  Habilidad(ID: 35, Name: "ESCUDO DE TORRE", Descripcion: "Gran pared móvil de madera y hierro. Esta carta defensiva utiliza su DEF para bloquear el ATQ enemigo; si el impacto supera la guardia, la estructura absorbe un 25% del daño restante mediante su función especial.", NV: 3, PDR: 50, ATQ: 20, DEF: 230, Color_Marco: Colors.blue, Image: "carta_0035.png", Rol: "DFS"),
  Habilidad(ID: 36, Name: "ARMADURA DE PLACAS", Descripcion: "Coraza metálica pesada que protege el cuerpo. Al activarse, su DEF mitiga el impacto de las cartas ofensivas y, en caso de que el ATQ rival sea superior, reduce automáticamente un 25% el daño restante final.", NV: 3, PDR: 80, ATQ: 0, DEF: 220, Color_Marco: Colors.blue, Image: "carta_0036.png", Rol: "DFS"),
  Habilidad(ID: 37, Name: "MURO GLACIAL", Descripcion: "Barrera mágica de hielo macizo. Esta carta defensiva usa su DEF para desviar impactos y, si el PDR del usuario es superior al del oponente, reduce un 25% el ATQ del enemigo durante el turno actual.", NV: 3, PDR: 100, ATQ: 50, DEF: 150, Color_Marco: Colors.blue, Image: "carta_0037.png", Rol: "DFS"),
  Habilidad(ID: 38, Name: "POSTURA DEL ROBLE", Descripcion: "Técnica marcial de enraizamiento y estabilidad. Esta carta defensiva utiliza su DEF para bloquear el ATQ enemigo y, si la DEF es superior al ataque recibido, el usuario recupera un 25% del valor de defensa como PS.", NV: 3, PDR: 70, ATQ: 30, DEF: 200, Color_Marco: Colors.blue, Image: "carta_0038.png", Rol: "DFS"),
  Habilidad(ID: 39, Name: "PIEDRA DE AFILAR", Descripcion: "Herramienta de mantenimiento para equipo de combate. Esta carta de estado utiliza su PDR para ganar iniciativa y aumenta un 50% el ATQ de la próxima carta ofensiva que el usuario juegue durante el próximo turno.", NV: 3, PDR: 120, ATQ: 80, DEF: 100, Color_Marco: Colors.white, Image: "carta_0039.png", Rol: "STD"),
  Habilidad(ID: 40, Name: "FRASCO DE ADRENALINA", Descripcion: "Sustancia química que acelera el ritmo cardíaco. Su función otorga prioridad al movimiento al aumentar el PDR del usuario en un 50% durante el próximo turno, asegurando el control del ritmo de combate.", NV: 3, PDR: 180, ATQ: 20, DEF: 100, Color_Marco: Colors.white, Image: "carta_0040.png", Rol: "STD"),
  Habilidad(ID: 41, Name: "BENDICIÓN SOLAR", Descripcion: "Energía luminosa que envuelve al portador. Esta carta de estado utiliza su valor de DEF como base para restaurar una cantidad equivalente de PS durante el turno actual, ignorando cualquier interacción con el ATQ enemigo.", NV: 3, PDR: 100, ATQ: 0, DEF: 200, Color_Marco: Colors.white, Image: "carta_0041.png", Rol: "STD"),
  Habilidad(ID: 42, Name: "DANZA RÍTMICA", Descripcion: "Movimiento corporal fluido que sincroniza la respiración con el combate. Esta carta de estado utiliza su elevado PDR para ganar la iniciativa y otorga un aumento del 25% al PDR del usuario durante el próximo turno, permitiendo encadenar acciones con mayor velocidad.", NV: 3, PDR: 180, ATQ: 60, DEF: 60, Color_Marco: Colors.white, Image: "carta_0042.png", Rol: "STD"),
];