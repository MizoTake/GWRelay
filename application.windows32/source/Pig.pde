class Pig extends BaseCharacter {
  
  private float _speedX, _speedY;
  private float _keepSize;
  
  Pig(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor = color(255, 255, 255);
    _speedX = random(-5, 5);
    _speedY = random(-5, 5);
    _size = 50;
    _keepSize = _size;
  }
  
  void update(){
    if(_position.x < 0 || _position.x > width){
      _speedX *= -1;
      _speedX *= 1.1;
      _size *= 1.1;
    }
    if(_position.y < 0 || _position.y > height){
      _speedY *= -1;
      _speedY *= 1.1;
      _size *= 1.1;
    }
    _position.x += _speedX;
    _position.y += _speedY;
    super.draw();
  }
  
  void draw(){
  
  }
  
}
