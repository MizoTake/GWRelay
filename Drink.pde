class Drink extends BaseCharacter {

  public static final int FIVE_SECOND_FRAME = 300; //出現
  public static final int TEN_SECOND_FRAME = 600;  //消える

  private float _speed;
  private int _frame_count;
  private boolean _appearance;

  Game _theParent;

  Drink( Game parent, float x, float y, PImage cImage ) {
    super(parent, x, y, cImage);
    reset();
    this._theParent = parent;
  }

  void update() {
    _frame_count++;


    if (_frame_count >= FIVE_SECOND_FRAME) {
      appearance();
      this.draw();
    } else {
      notExist();
    }


    super.draw();
  }

  void draw() {
    
  }

  void appearance() {
    if (_appearance == false) {
      _position.x = random(width);
      _position.y = 100 + random(height / 2 * 0.7);
      _appearance = true;
    }
    if (_frame_count >= TEN_SECOND_FRAME) {
      _position.x = width * 1.1;
      _position.y = height * 1.1;
      
      
      
      for(int i = 0; i < _theParent._playerCharacter.length; i++){
      if(hitTest(this, _theParent._playerCharacter[i], 50)){
        _speed *= -1;
        _theParent._gameTime += 10;
      }
      }
      
      
      /*
      if(hitTest(this, _theParent._pig, 500)){
        println("aaaaaaaaaa");
         _theParent._gameTime -= 5;
      }
      */
      
      
      reset();
    } else {
        _position.x += _speed;
        if (_position.x <= 0 || _position.x >= width) {
          _speed *= -1;
        }
    }
  }

  void notExist() {
  }

  void reset() {
    _speed = 5;
    _frame_count = 0;
    _appearance = false;
  }
}

