class BaseCharacter{
  
  //-----Constant------
  public static final int RED = 0;
  public static final int GREEN = 1;
  public static final int BLUE = 2;
  
  
  //-----Field---------
  protected Game _theParent;
  protected PVector _position;
  private boolean _press;
  
  public BaseCharacter(Game parent, float x, float y){
    _theParent = parent;
    _position = new PVector(0, 0);
    _position.x = x;
    _position.y = y;
    _press = false;
  }
  
  public void update(){
    
    this.draw();
  }
  
  public void draw(){
    
  }
  
  //カラーナンバーを見て色を返すメソッド
  public color assignColor(int colorNumber){
    color result = color(0, 0, 0);
    switch(colorNumber){
    case RED:
      result = color(255, 0, 0);
      break;
    case GREEN:
      result = color(0, 255, 0);
      break;
    case BLUE:
      result = color(0, 0, 255);
      break;
    }
    return result;
  }
  
  //当たり判定メソッド
  public boolean hitTest(BaseCharacter me, BaseCharacter enemy, float range){
    boolean result = false;
    float dist = sqrt(sq(enemy._position.x - me._position.x) + sq(enemy._position.y - me._position.y));
    if(dist <= range)result = true;
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
}
