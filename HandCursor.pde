class HandCursor extends BaseCharacter {
  
  private PImage _defaultSprite;
  private PImage _clickSprite;
  private int _state;
  private int _currentState;
  
  
  public void setDefaultImage(PImage image){
    _defaultSprite = image;
  }
  
  public void setClickImage(PImage image){
    _clickSprite = image;
  }
  
  
  public int getState(){
    return _state;
  }
  
  public void setState(int state){
    _state = state;
  }
  
  HandCursor(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor = color(255, 255, 255);
  }
  
  void update(){
    
    switch(_state){
      case 0:
        if(_state != _currentState){
          _characterImage = _defaultSprite;
        }
        
        _position.x = mouseX;
        _position.y = mouseY;
        break;
      case 1:
        if(_state != _currentState){
          _characterImage = _clickSprite;
        }
        
        _position.x = mouseX;
        break;
    }
    
    _currentState = _state;
    println(""+ _state + ", " + _currentState);
    
    super.draw();
  }
  
  void draw(){
  
  }
  
}
