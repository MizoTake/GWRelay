class Dona extends BaseCharacter {
  
  public boolean _alive;
  private int _aliveCount;
  
  Dona(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor = color(255, 255, 255);
    _alive = false;
    _size = 90;
    _aliveCount = 0;
  }
  
  void update(){
    if(_alive){
      draw();
      _aliveCount++;
      if(_aliveCount >= 50){
        _alive = false;
        _aliveCount = 0;
      }
    }
  }
  
  void draw(){
    super.draw();
  }
  
}
