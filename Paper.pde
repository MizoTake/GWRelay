class Paper extends BaseCharacter { //Old man class.

  private final int COUNT_MAX = 100;
  
  private float _power; 
  private float _acceleration;
  private int   _count;
  
  Paper(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor      = color(255, 255, 255);
    _position.x   = x;
    _position.y   = y;
    _size         = 65.0;
    _acceleration = 0.1;
    _power        = 1.5;
    _count        = 0;
  }
  
  void update(){
    if( (_position.x < 0 && _count > COUNT_MAX) || (_position.x > width && _count > COUNT_MAX) ){
      _power       *= -1.0;
      _acceleration = 0.1;
      _count        = 0;
    }
    
    if(_count <= COUNT_MAX){
      _count++;
    }
    
    _acceleration *= 1.009;
    _position.x   += ( _power * _acceleration);   
    
    super.draw();
  }
  
  void draw(){
  }
  
}
