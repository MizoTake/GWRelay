class Game{
  //-----Constant-------
  static final int TITLE_SCENE = 0;
  static final int GAME_SCENE = 1;
  static final int OVER_SCENE = 2;
  static final int CLEAR_SCENE = 3;
  static final int GAME_TIME_MAX = 1;
  static final int MOVE_CHARA_MAX = 3;
  static final int STOP_CHARA_MAX = 3;
  static final int BIGMAC_SIZE = 15360;
  
  //-----Field-------
  private int _sceneState;
  private int _gameTime;
  private float _bigmacSizeWidth;
  private float _bigmacSizeHeight;
  private float _bigmacSpeed;
  private float _gameFrameCounter;
  PlayerCharacter[] _playerCharacter;
  EnemyCharacter[] _enemyCharacter;
  HandCursor _hand;
  Pig _pig;
  PImage _potato;
  PImage _ham;
  PImage _pigImage;
  PImage _bigmac;
  PImage _hand_default;
  PImage _hand_catch;

  public Game(){
    rectMode(CENTER);
    textAlign(CENTER);
    initializeGameScene();
    _potato = loadImage("potato.png");
    _ham = loadImage("ham.png");
    _pigImage = loadImage("pig.png");
    _bigmac = loadImage("bigmac.png");
    _hand_default = loadImage("p_hand.png");
    _hand_catch = loadImage("g_hand.png");
    _sceneState = TITLE_SCENE;
    _aPlayer.loop();
    _bigmacSizeWidth = BIGMAC_SIZE;
    _bigmacSizeHeight = BIGMAC_SIZE;
    _bigmacSpeed = 50;
    
    noCursor();
  } 
  
  public void update(){
    switch(_sceneState){
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
  public void playTitleScene(){
    background(0, 155, 0);
    image(_bigmac, width/2 - _bigmacSizeWidth/2, height/2 - _bigmacSizeHeight/2, _bigmacSizeWidth, _bigmacSizeHeight);
    if(_bigmacSizeWidth <= 480 || _bigmacSizeHeight <= 480){
      _bigmacSizeWidth = 480;
      _bigmacSizeHeight = 480;
    }else{
      _bigmacSizeWidth -= _bigmacSpeed;
      _bigmacSizeHeight -= _bigmacSpeed;
    }
    fill(100, 255, 100);
    textSize(30);
    text("ColorShooter", width / 2, height / 2);
    textSize(20);
    text("Press Enter", width / 2, height / 2 + 40);
    text("Go to Game", width / 2, height / 2 + 70);
    if(pressEnter()){
      initializeGameScene();
      _sceneState = GAME_SCENE;
      _aPlayer.close();
    }
  }
  
  //ゲーム画面の変数初期化
  public void initializeGameScene(){
    //タイム変数の初期化
    _gameTime = GAME_TIME_MAX;
    _gameFrameCounter = 0;
    
    //キャラクターの初期化
    _playerCharacter = new PlayerCharacter[MOVE_CHARA_MAX];
    _enemyCharacter = new EnemyCharacter[STOP_CHARA_MAX];
    
    _hand = new HandCursor(this, mouseX, mouseY, _hand_default);
    _hand.setDefaultImage(_hand_default);
    _hand.setClickImage(_hand_catch);
    
    for(int i = 0; i < _playerCharacter.length; i++){
      _playerCharacter[i] = new PlayerCharacter(this, 100 + i * 200, height - 100, i, _potato);
    }
    
    int colorNumber = 0;
    for(int i = 0; i < _enemyCharacter.length; i++){
      _enemyCharacter[i] = new EnemyCharacter(this, 180 + i * 60, 100, colorNumber, _ham);
      colorNumber++;
      if(colorNumber > 2)colorNumber = 0;
    }
    //動かないブロックの位置をシャッフルする
    for(int i = 0; i < _enemyCharacter.length; i++){
      PVector memo = _enemyCharacter[i]._position;
      int randomNumber = (int)random(_enemyCharacter.length);
      _enemyCharacter[i]._position = _enemyCharacter[randomNumber]._position;
      _enemyCharacter[randomNumber]._position = memo;
    }
    
    _pig = new Pig(this, width/2, height/2, _pigImage);
  }
  
  public void playGameScene(){
    //時間の計算と表示
    _gameFrameCounter++;
    if(_gameFrameCounter >= 60){
      _gameFrameCounter = 0;
      _gameTime--;
    }
    fill(0);
    textSize(20);
    text("Time: " + _gameTime, width - 100, 50);
    //タイムオーバー処理
    if(_gameTime <= 0){
      _sceneState = OVER_SCENE;
    }
   
    //キャラクターの更新処理
    int cnt = 0;
    for(int i = 0; i < _enemyCharacter.length; i++){
      _enemyCharacter[i].update();
      if(_enemyCharacter[i].getStatus() == 1){
        cnt += 1;
      }
    }
    if(cnt >= _enemyCharacter.length){
      _sceneState = CLEAR_SCENE;
    }
    
    for(int i = 0; i < _playerCharacter.length; i++){
      _playerCharacter[i].update();
    }
    
    _hand.update();
    
    _pig.update();
  }
  
  //ゲームオーバー画面の処理
  public void playOverScene(){
    background(155, 0, 0);
    fill(255, 100, 100);
    textSize(30);
    text("Game Over", width / 2, height / 2);
    textSize(20);
    text("Press Enter", width / 2, height / 2 + 40);
    text("Go to Title", width / 2, height / 2 + 70);
    if(pressEnter()){
      _sceneState = TITLE_SCENE;
      _aPlayer.loop();
    }
  }
  
  //ゲームクリアー画面の処理
  public void playClearScene(){
    background(0, 0, 155);
    fill(100, 100, 255);
    textSize(30);
    text("Game Clear", width / 2, height / 2);
    textSize(20);
    text("Press Enter", width / 2, height / 2 + 40);
    text("Go to Title", width / 2, height / 2 + 70);
    if(pressEnter()){
      _sceneState = TITLE_SCENE;
      _aPlayer.loop();
    }
  }
}
