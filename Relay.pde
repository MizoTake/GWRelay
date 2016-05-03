private Game _theGame;
private boolean _pressEnter;

void setup(){
  size(640, 480);
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


