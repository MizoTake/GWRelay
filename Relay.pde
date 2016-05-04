import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

private Game _theGame;
Minim _minim;
AudioPlayer _aPlayer;
AudioPlayer _sPlayer;
AudioPlayer _oldman;
private boolean _pressEnter;

void setup(){
  size(640, 480);
  _minim = new Minim(this);
  _aPlayer = _minim.loadFile("potato.mp3");
  _sPlayer = _minim.loadFile("ringtone.wav");
  _oldman  = _minim.loadFile("oldman.mp3");
  _theGame = new Game();
  _pressEnter = false;
}

void draw(){
  background(255);
  _theGame.update();
}

public boolean pressEnter(){
  boolean result = false;
  if(keyPressed && key == ENTER){
    _pressEnter = true;
  } else {
    if(_pressEnter){
      result = true;
      _pressEnter = false;
    }
  }
  return result;
}


