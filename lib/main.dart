import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() {
  MoviendoObjetos muestra = MoviendoObjetos();
  runApp(
      GameWidget(game: muestra,
      ),
  );
}

class Cuadrado extends PositionComponent
{
  late double dimension;
  late double angulo;
  late Vector2 vector;
  late Paint paint;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(dimension, dimension);
    anchor = Anchor.center;
    paint.strokeWidth = 2;

  }

  @override
  void update(double dt) {
    super.update(dt);
    // speed is refresh frequency independent
    position += vector * dt;
    var anguloDelta = dt * angulo;
    angle = (angle - anguloDelta) % (2 * pi);
  }

  @override
  //
  // render the shape
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint);
  }
}

class MoviendoObjetos extends FlameGame with DoubleTapDetector, TapDetector
{
  bool corriendo = true;
  var rnd = Random();

  @override
  bool debugMode = false; //on off extra data

  final TextPaint etiqueta = TextPaint(
    style: const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Awesome Font',
      color: Colors.white
    ),
  );

  @override
  void onTapUp(TapUpInfo info)
  {
    final puntoTocaado = info.eventPosition.global;
    final objetoTocado = children.any((componente)
    {
      if(componente is Cuadrado && componente.containsPoint(puntoTocaado))
      {
        componente.vector.negate();
        return true;
      }
      else {
        return false;
      }
    });

    if(!objetoTocado)
    {
      Cuadrado agregar = Cuadrado();
      agregar.position = puntoTocaado;
      agregar.dimension = rnd.nextDouble() * 50;
      agregar.angulo = rnd.nextDouble() * 2;
      var vect1 = rnd.nextDouble() * -1;
      agregar.vector = Vector2(0,vect1).normalized() * (rnd.nextDouble() * 30);
      agregar.paint = crearPaint();

      add(agregar);

    }
  }

  Paint crearPaint() {

    int aleatorioColor = rnd.nextInt(12);
    Paint color = Paint();
    bool aleatorioFill = rnd.nextBool();

    switch (aleatorioColor) {
      case 0:
        color = BasicPalette.magenta.paint();
      case 1:
        color = BasicPalette.red.paint();
      case 2:
        color = BasicPalette.yellow.paint();
      case 3:
        color = BasicPalette.blue.paint();
      case 4:
        color = BasicPalette.cyan.paint();
      case 5:
        color = BasicPalette.green.paint();
      case 6:
        color = BasicPalette.pink.paint();
      case 7:
        color = BasicPalette.purple.paint();
      case 8:
        color = BasicPalette.orange.paint();
      case 9:
        color = BasicPalette.white.paint();
      case 10:
        color = BasicPalette.lime.paint();
      case 11:
        color = BasicPalette.brown.paint();
      case 12:
        color = BasicPalette.gray.paint();
    }

    if(aleatorioFill) {
      color.style = PaintingStyle.stroke;
    } else{
      color.style = PaintingStyle.fill;
    }

    return color;
  }

  @override
  void onDoubleTap() {
    if (corriendo) {
      pauseEngine();
    } else {
      resumeEngine();
    }
    corriendo = !corriendo;
  }

  @override
  void render(Canvas canvas) {
    etiqueta.render(canvas, 'Objetos Activos: ${children.length}', Vector2(60, 20), anchor: Anchor.center);
    super.render(canvas);
  }

}

