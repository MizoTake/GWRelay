class Game{
  //-----Constant-------
  static final int TITLE_SCENE = 0;
  static final int GAME_SCENE = 1;
  static final int OVER_SCENE = 2;
  static final int CLEAR_SCENE = 3;
  static final int GAME_TIME_MAX = 30;
  static final int MOVE_CHARA_MAX = 3;
  static final int STOP_CHARA_MAX = 3;
  
  //-----Field-------
  private int _sceneState;
  private int _gameTime;
  private float _gameFrameCounter;
  private PlayerCharacter[] _playerCharacter;
  private EnemyCharacter[] _enemyCharacter;
  
 
  public Game(){
    rectMode(CENTER);
    textAlign(CENTER);
    initializeGameScene();
    _sceneState = TITLE_SCENE;
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
    fill(100, 255, 100);
    textSize(30);
    text("ColorShooter", width / 2, height / 2);
    textSize(20);
    text("Press Enter", width / 2, height / 2 + 40);
    text("Go to Game", width / 2, height / 2 + 70);
    if(pressEnter()){
      _sceneState = GAME_SCENE;
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
    for(int i = 0; i < _playerCharacter.length; i++){
      _playerCharacter[i] = new PlayerCharacter(this, 100 + i * 200, height - 100, i);
    }
    
    int colorNumber = 0;
    for(int i = 0; i < _enemyCharacter.length; i++){
      _enemyCharacter[i] = new EnemyCharacter(this, 180 + i * 60, 100, colorNumber);
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
    for(int i = 0; i < _enemyCharacter.length; i++){
      _enemyCharacter[i].update();
    }
    for(int i = 0; i < _playerCharacter.length; i++){
      _playerCharacter[i].update();
    }
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
    }
  }
}
