class PlayerCharacter extends BaseCharacter{
  //----Constant-----
  static final float MY_WIDTH = 20;
  static final float MY_HEIGHT = 40;
  static final int STOP_STATE = 0;
  static final int MOVE_STATE = 1;
  static final int SHOT_STATE = 2;
  static final int SHOT_SPEED = 15;
  
  //----Field----
  private int _colorNumber;
  private color _myColor;
  private int _moveState;
  private boolean _press;
  private float _memoryPositionX, _memoryPositionY;
  
  public PlayerCharacter(Game parent, float x, float y, int colorNumber){
    super(parent, x, y);
    _colorNumber = colorNumber;
    _myColor = assignColor(colorNumber);
    _moveState = STOP_STATE;
    _press = false;
    _memoryPositionX = _position.x;
    _memoryPositionY = _position.y;
  }
  
  public void update(){
    switch(_moveState){
    case STOP_STATE:
      if(mouseReleaseMoment()){
        //マウスが押された瞬間動く状態へ遷移
        if(_position.x + MY_WIDTH / 2 >= mouseX && _position.x - MY_WIDTH / 2 <= mouseX){
          if(_position.y + MY_HEIGHT / 2 >= mouseY && _position.y - MY_HEIGHT / 2 <= mouseY){
            _moveState = MOVE_STATE;
          }
        }
      }
      
      //初期位置に移動
      _position.x = _memoryPositionX;
      _position.y = _memoryPositionY;
      break;
    case MOVE_STATE:
      //位置をマウスの位置に同期
      _position.x = mouseX;
      //マウスが押された瞬間動かない状態へ遷移
      if(mouseReleaseMoment()){
        _moveState = SHOT_STATE;
      }
      break;
    case SHOT_STATE:
      //y座標を減算して、飛んでいるように見せる
      _position.y -= SHOT_SPEED;
      if(_position.y <= 0){
        _moveState = STOP_STATE;
      }
      
      //すべての的ブロックとの当たり判定
      for(int i = 0; i < _theParent._enemyCharacter.length; i++){
        if(hitTest(this, _theParent._enemyCharacter[i], 30)){
          //色が同じだった場合、的ブロックが飛ぶ
          if(_theParent._enemyCharacter[i].getColorNumber() == _colorNumber){
            _theParent._enemyCharacter[i].flyAway();
            _moveState = STOP_STATE;
          }
        }
      }
      break;
    }
    this.draw();
  }
  
  public void draw(){
    fill(_myColor);
    rect(_position.x, _position.y, MY_WIDTH, MY_HEIGHT);
  }
}
