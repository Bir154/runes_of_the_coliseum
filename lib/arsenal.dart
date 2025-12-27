import 'package:flutter/material.dart';

class Habilidad {
  final String id, nombre, imagenRef, descripcion;
  final Color colorMarco;
  final int nv, pdr, atq, def;
  final List<String> fortalezas, debilidades;

  Habilidad({
    required this.id, required this.nombre, required this.colorMarco, 
    required this.nv, required this.pdr, required this.atq, required this.def, 
    required this.imagenRef,
    this.descripcion = "Información técnica no disponible.",
    this.fortalezas = const ["---", "---", "---"],
    this.debilidades = const ["---", "---", "---"]
  });
}

// AQUÍ PUEDES AGREGAR CARTAS EN UNA SOLA LÍNEA [cite: 2025-11-10]
final List<Habilidad> arsenalMaestro = [
  Habilidad(id: "0001", nombre: "Impacto Ígneo", colorMarco: Colors.red, nv: 1, pdr: 100, atq: 85, def: 15, imagenRef: "fuego", descripcion: "Lanza una bola de fuego concentrada.", fortalezas: ["Daño", "Quemadura", "Ímpetu"], debilidades: ["Agua", "Lento", "Costo"]),
  Habilidad(id: "0011", nombre: "Godzilla Mariwano", colorMarco: Colors.green, nv: 7, pdr: 999, atq: 999, def: 999, imagenRef: "godzilla"),
  Habilidad(id: "0012", nombre: "Rayo Gamma", colorMarco: Colors.white, nv: 5, pdr: 500, atq: 600, def: 50, imagenRef: "rayo", descripcion: "Radiación pura.", fortalezas: ["Alcance", "Veneno", "Luz"], debilidades: ["Plomo", "Espejo", "Día"]),
];