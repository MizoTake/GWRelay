class Obon extends BaseCharacter {
  //------Constant--------
  //static final int MY_WIDTH = 60;
  //static final int MY_HEIGHT = 60;
  static final float FLY_SPEED = 15;
  static final int MOVE_STATE = 0;
  static final int FLY_STATE = 1;
  static final int MOVE_SPEED_MAX = 10;
  static final int MOVE_FRAME_MIN = 30;
  static final int MOVE_FRAME_MAX = 100;

  //------Field--------
  private int _colorNumber;
  //private color _myColor;
  private int _moveState;
  private int _moveFrame;
  private int _moveSpeed;


  public Obon(Game parent, float x, float y, int colorNumber, PImage cImage) {
    //変数の初期化
    super(parent, x, y, cImage);
    _colorNumber = colorNumber;
    _myColor = assignColor(colorNumber);
    _moveState = MOVE_STATE;
    _moveSpeed = (int)random(-MOVE_SPEED_MAX, MOVE_SPEED_MAX);
    _moveFrame = (int)random(MOVE_FRAME_MIN, MOVE_FRAME_MAX);
  }

  public void update() {
    switch(_moveState) {
    case MOVE_STATE:
      //X座標をランダムに移動。壁にぶつかったら反転
      _position.x += _moveSpeed;
      if (_position.x <= 0 || _position.x >= width) {
        _moveSpeed *= -1;
        _position.x += _moveSpeed;
      }
      //移動できるフレーム数が０になったら、もう一度ランダムで移動スピードとフレーム数を決める
      _moveFrame--;
      if (_moveFrame < 0) {
        _moveSpeed = (int)random(-MOVE_SPEED_MAX, MOVE_SPEED_MAX);
        _moveFrame = (int)random(MOVE_FRAME_MIN, MOVE_FRAME_MAX);
      }
      break;
    case FLY_STATE:
      //上方へ移動
      _position.y -= FLY_SPEED;
      break;
    }
    for (int i = 0; i < _theParent._playerCharacter.length; i++) {
      if (hitTest(this, _theParent._playerCharacter[i], 30)) {
        //色が同じだった場合、的ブロックが飛ぶ
        if (this.getColorNumber() == _theParent._playerCharacter[i]._colorNumber) {
          this.flyAway();
          playSound(1);
         // _theParent._playerCharacter[i]._moveState = 0;
        }
      }
    }
    super.draw();
  }

  public void draw() {
    //fill(_myColor);
    //rect(_position.x, _position.y, MY_WIDTH, MY_HEIGHT);
  }

  public int getStatus() {
    return _moveState;
  }

  //カラーナンバーのゲッター
  public int getColorNumber() {
    return _colorNumber;
  }

  //飛ぶ処理をonにする
  public void flyAway() {
    _moveState = FLY_STATE;
  }
}

