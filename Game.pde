class Game {
  //-----Constant-------
  static final int TITLE_SCENE = 0;
  static final int GAME_SCENE = 1;
  static final int OVER_SCENE = 2;
  static final int CLEAR_SCENE = 3;
  static final int GAME_TIME_MAX = 60;
  static final int MOVE_CHARA_MAX = 3;
  static final int STOP_CHARA_MAX = 3;
  static final int PIG_MAX = 5;
  static final int BIGMAC_SIZE = 15360;

  //-----Field-------
  private int _sceneState;
  private int _gameTime;
  private float _bigmacSizeWidth;
  private float _bigmacSizeHeight;
  private float _bigmacSpeed;
  private float _gameFrameCounter;
  private boolean _pigBorn;
  PlayerCharacter[] _playerCharacter;
  EnemyCharacter[] _enemyCharacter;
  HandCursor _hand;
  Pig[] _pig;
  Drink _drink;
  Paper _paper;
  Dona _dona;
  Obon[] _obon;
  PImage _potato;
  PImage _ham;
  PImage _pigImage;
  PImage _paperImage;
  PImage _bigmac;
  PImage _hand_default;
  PImage _hand_catch;
  PImage _drinkImage;
  PImage _donaImage;
  PImage _polis;
  PImage _obonImage;
  PImage _backImage;

  public Game() {
    rectMode(CENTER);
    textAlign(CENTER);
    initializeGameScene();
    _potato = loadImage("potato.png");
    _ham = loadImage("ham.png");
    _obonImage = loadImage("food_sample_tray.png");
    _pigImage = loadImage("pig.png");
    _bigmac = loadImage("bigmac.png");
    _hand_default = loadImage("p_hand.png");
    _hand_catch = loadImage("g_hand.png");
    _drinkImage = loadImage("drink.png");
    _paperImage = loadImage("oldman.png");
    _donaImage = loadImage("dona.png");
    _polis = loadImage("keisatusyo.png");
    _backImage = loadImage("back.png");
    _sceneState = TITLE_SCENE;
    _aPlayer.loop();
    _bigmacSizeWidth = BIGMAC_SIZE;
    _bigmacSizeHeight = BIGMAC_SIZE;
    _bigmacSpeed = 50;

    noCursor();
  } 

  public void update() {
    switch(_sceneState) {
    case TITLE_SCENE:
      playTitleScene();
      break;
    case GAME_SCENE:
      playGameScene();
      break;
    case OVER_SCENE:
      playOverScene();
      break;
    case CLEAR_SCENE:
      playClearScene();
      break;
    }
  }

  //タイトル画面の処理
  public void playTitleScene() {
    background(0, 155, 0);
    image( _bigmac, width/2 - _bigmacSizeWidth/2, height/2 - _bigmacSizeHeight/2, _bigmacSizeWidth, _bigmacSizeHeight );
    if ( _bigmacSizeWidth <= 480 || _bigmacSizeHeight <= 480 ) {
      _bigmacSizeWidth = 480;
      _bigmacSizeHeight = 480;
    } else {
      _bigmacSizeWidth -= _bigmacSpeed;
      _bigmacSizeHeight -= _bigmacSpeed;
    }
    fill( 100, 255, 100 );
    textSize(30);
    text( "ColorShooter", width / 2, height / 2 );
    textSize(20);
    text( "Press Enter", width / 2, height / 2 + 40 );
    text( "Go to Game", width / 2, height / 2 + 70 );
    if (pressEnter()) {
      initializeGameScene();
      _sceneState = GAME_SCENE;
      _aPlayer.close();
      _sPlayer.play();
      _oldman.loop();
    }
  }

  //ゲーム画面の変数初期化
  public void initializeGameScene() {
    //タイム変数の初期化
    _gameTime = GAME_TIME_MAX;
    _gameFrameCounter = 0;
    
    //キャラクターの初期化
    _playerCharacter = new PlayerCharacter[MOVE_CHARA_MAX];
    _obon = new Obon[MOVE_CHARA_MAX];
    _enemyCharacter = new EnemyCharacter[STOP_CHARA_MAX];
    
    _hand = new HandCursor( this, mouseX, mouseY, _hand_default );
    _hand.setDefaultImage(_hand_default);
    _hand.setClickImage(_hand_catch);
    
    for (int i = 0; i < _playerCharacter.length; i++) {
      _playerCharacter[i] = new PlayerCharacter( this, 100 + i * 200, height - 100, i, _potato );
    }

    int colorNumber = 0;
    for ( int i = 0; i < _enemyCharacter.length; i++ ) {
      _enemyCharacter[i] = new EnemyCharacter( this, 180 + i * 60, 100, colorNumber, _ham );
      _obon[i] = new Obon( this, 180 + i * 60, height / 2, colorNumber, _obonImage );
      colorNumber++;
      if (colorNumber > 2)colorNumber = 0;
    }
    //動かないブロックの位置をシャッフルする
    for ( int i = 0; i < _enemyCharacter.length; i++ ) {
      PVector memo = _enemyCharacter[i]._position;
      int randomNumber = (int)random( _enemyCharacter.length );
      _enemyCharacter[i]._position = _enemyCharacter[randomNumber]._position;
      _enemyCharacter[randomNumber]._position = memo;
    }
    
    _pigBorn = false;
    _pig = new Pig[PIG_MAX];
    for ( int i = 0; i < _pig.length; i++ ) {
      _pig[i] = new Pig( this, width/2, height/2, _pigImage );
    }


    _paper = new Paper( this, width/2, height/2, _paperImage );
    _drink = new Drink( this, width * 1.1, height * 1.1, _drinkImage );
    _dona = new Dona( this, width - 45, height - 45, _donaImage );
  }

  public void playGameScene() {
    image(_polis, 10, height - 60 );
    //時間の計算と表示
    _gameFrameCounter++;
    if (_gameFrameCounter >= 60) {
      _gameFrameCounter = 0;
      _gameTime--;
    }
    fill(0);
    textSize(20);
    text("Time: " + _gameTime, width - 100, 50);
    //タイムオーバー処理
    if (_gameTime <= 0) {
      _sceneState = OVER_SCENE;
    }
    _drink.update();
    //キャラクターの更新処理
    int cnt = 0;
    for (int i = 0; i < _enemyCharacter.length; i++) {
      _enemyCharacter[i].update();
      _obon[i].update();
      if (_enemyCharacter[i].getStatus() == 1) {
        cnt += 1;
      }
    }
    if (cnt >= _enemyCharacter.length) {
      _sceneState = CLEAR_SCENE;
    }

    for (int i = 0; i < _playerCharacter.length; i++) {
      _playerCharacter[i].update();
    }
    // Pig
    for ( int i = 0; i < _pig.length; i ++ ) {
      // pig move 
      if ( _pig[i]._size >= 100 ) {
        _pig[i]._size = 30;
        _pig[i]._speedX = random(-5, 5);
        _pig[i]._speedY = random(-5, 5);
        if ( !_pigBorn ) {
          _pigBorn = true;
        }
      }
      if (_pigBorn ) {
        _pig[i].update();
      }
    }
    if (!_pigBorn ) {
      _pig[0].update();
    } 
    
    if( _dona._alive ){
      _dona._position.x -= 1;
      if( _dona._position.x <= 50 ){
        _sceneState = OVER_SCENE;
      }
    }
    _paper.update();

    _hand.update();

    _dona.update();
  }

  //ゲームオーバー画面の処理
  public void playOverScene() {
    _sPlayer.close();
    _oldman.close();
    background( 155, 0, 0 );
    fill( 255, 100, 100 );
    textSize(30);
    text( "Game Over", width / 2, height / 2 );
    textSize(20);
    text( "Press Enter", width / 2, height / 2 + 40 );
    text( "Go to Title", width / 2, height / 2 + 70 );
    if ( pressEnter() ) {
      _sceneState = TITLE_SCENE;
      _aPlayer.loop();
    }
  }

  //ゲームクリアー画面の処理
  public void playClearScene() {
    _sPlayer.close();
    _oldman.close();
    background( 0, 0, 155 );
    fill( 100, 100, 255 );
    textSize( 30 );
    text( "Game Clear", width / 2, height / 2 );
    textSize( 20 );
    text( "Press Enter", width / 2, height / 2 + 40 );
    text( "Go to Title", width / 2, height / 2 + 70 );
    if (pressEnter()) {
      _sceneState = TITLE_SCENE;
      _aPlayer.loop();
    }
  }
}

