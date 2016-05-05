class BaseCharacter{
  
  //-----Constant------
  public static final int RED = 0;
  public static final int GREEN = 1;
  public static final int BLUE = 2;
  
  
  //-----Field---------
  protected Game _theParent;
  protected PVector _position;
  private boolean _press;
  protected PImage _characterImage;
  protected float _size;
  protected color _myColor;


  
  public BaseCharacter(Game parent, float x, float y, PImage cImage){
    _theParent = parent;
    _position = new PVector(0, 0);
    _position.x = x;
    _position.y = y;
    _press = false;
    _characterImage = cImage;
    _size = 30;
  }
  
  public void update(){
    
    this.draw();
  }
  
  protected void draw(){
    tint(_myColor);
    image(_characterImage, _position.x - _size/2, _position.y - _size/2, _size, _size);
  }
  
  //カラーナンバーを見て色を返すメソッド
  public color assignColor(int colorNumber){
    color result = color(0, 0, 0, 0);
    switch(colorNumber){
    case RED:
      result = color(255, 200, 200);
      break;
    case GREEN:
      result = color(200, 255, 200);
      break;
    case BLUE:
      result = color(200, 200, 255);
      break;
    }
    return result;
  }
  
  //当たり判定メソッド
  public boolean hitTest(BaseCharacter me, BaseCharacter enemy, float range){
    boolean result = false;
    float dist = sqrt(sq(enemy._position.x - me._position.x) + sq(enemy._position.y - me._position.y));
    if(dist <= range){
      _myColor += color(-100, -100, 0);
      result = true;
    }
    return result;
  }
  
  //マウスを押した一瞬だけtrueを返すメソッド
  public boolean mouseReleaseMoment(){
    boolean result = false;
    if(mousePressed){
      if(_press == true){
        result = true;
        _press = false;
      }
    } else {
      _press = true;
    }
    
    return result;
  }
  
  public void playSound(int num){
    switch (num){
      case 0:
        _failure.rewind();
        _failure.play();
        break;
      case 1:
        _success.rewind();
        _success.play();
        break;
        
    } 
  }
}
