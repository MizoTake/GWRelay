import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.spi.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Relay extends PApplet {








private Game _theGame;
Minim _minim;
AudioPlayer _aPlayer;
AudioPlayer _sPlayer;
AudioPlayer _oldman;
AudioPlayer _failure;
AudioPlayer _success;
private boolean _pressEnter;

public void setup(){
  size(640, 480);
  _minim = new Minim(this);
  _aPlayer = _minim.loadFile("potato.mp3");
  _sPlayer = _minim.loadFile("ringtone.mp3");
  _oldman  = _minim.loadFile("oldman.mp3");
  _failure = _minim.loadFile("failure.mp3");
  _success = _minim.loadFile("success.mp3");
  _theGame = new Game();
  _pressEnter = false;
}

public void draw(){
  background(255);
  _theGame.update();
}

public boolean pressEnter(){
  boolean result = false;
  if(keyPressed && key == ENTER){
    _pressEnter = true;
  } else {
    if(_pressEnter){
      result = true;
      _pressEnter = false;
    }
  }
  return result;
}


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
  protected int _myColor;


  
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
  
  //\u30ab\u30e9\u30fc\u30ca\u30f3\u30d0\u30fc\u3092\u898b\u3066\u8272\u3092\u8fd4\u3059\u30e1\u30bd\u30c3\u30c9
  public int assignColor(int colorNumber){
    int result = color(0, 0, 0, 0);
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
  
  //\u5f53\u305f\u308a\u5224\u5b9a\u30e1\u30bd\u30c3\u30c9
  public boolean hitTest(BaseCharacter me, BaseCharacter enemy, float range){
    boolean result = false;
    float dist = sqrt(sq(enemy._position.x - me._position.x) + sq(enemy._position.y - me._position.y));
    if(dist <= range){
      _myColor += color(-100, -100, 0);
      result = true;
    }
    return result;
  }
  
  //\u30de\u30a6\u30b9\u3092\u62bc\u3057\u305f\u4e00\u77ac\u3060\u3051true\u3092\u8fd4\u3059\u30e1\u30bd\u30c3\u30c9
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
class Dona extends BaseCharacter {
  
  public boolean _alive;
  private int _aliveCount;
  
  Dona(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor = color(255, 255, 255);
    _alive = false;
    _size = 90;
    _aliveCount = 0;
  }
  
  public void update(){
    if(_alive){
      draw();
      _aliveCount++;
      if(_aliveCount >= 50){
        _alive = false;
        _aliveCount = 0;
      }
    }
  }
  
  public void draw(){
    super.draw();
  }
  
}
class Drink extends BaseCharacter {

  public static final int FIVE_SECOND_FRAME = 300; //\u51fa\u73fe
  public static final int TEN_SECOND_FRAME = 600;  //\u6d88\u3048\u308b

  private float _speed;
  private int _frame_count;
  private boolean _appearance;

  Game _theParent;

  Drink( Game parent, float x, float y, PImage cImage ) {
    super(parent, x, y, cImage);
    reset();
    this._theParent = parent;
  }

  public void update() {
    _frame_count++;


    if (_frame_count >= FIVE_SECOND_FRAME) {
      appearance();
      this.draw();
    } else {
      notExist();
    }


    super.draw();
  }

  public void draw() {
    
  }

  public void appearance() {
    if (_appearance == false) {
      _position.x = random(width);
      _position.y = 100 + random(height / 2 * 0.7f);
      _appearance = true;
    }
    if (_frame_count >= TEN_SECOND_FRAME) {
      _position.x = width * 1.1f;
      _position.y = height * 1.1f;
      
      
      
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

  public void notExist() {
  }

  public void reset() {
    _speed = 5;
    _frame_count = 0;
    _appearance = false;
  }
}

class EnemyCharacter extends BaseCharacter{
  //------Constant--------
  //static final int MY_WIDTH = 60;
  //static final int MY_HEIGHT = 60;
  static final float FLY_SPEED = 5;
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
  
  
  public EnemyCharacter(Game parent, float x, float y, int colorNumber, PImage cImage){
    //\u5909\u6570\u306e\u521d\u671f\u5316
    super(parent, x, y, cImage);
    _colorNumber = colorNumber;
    _myColor = assignColor(colorNumber);
    _moveState = MOVE_STATE;
    _moveSpeed = (int)random(-MOVE_SPEED_MAX, MOVE_SPEED_MAX);
    _moveFrame = (int)random(MOVE_FRAME_MIN, MOVE_FRAME_MAX);
  }
  
  public void update(){
    switch(_moveState){
    case MOVE_STATE:
      //X\u5ea7\u6a19\u3092\u30e9\u30f3\u30c0\u30e0\u306b\u79fb\u52d5\u3002\u58c1\u306b\u3076\u3064\u304b\u3063\u305f\u3089\u53cd\u8ee2
      _position.x += _moveSpeed;
      if(_position.x <= 0 || _position.x >= width){
        _moveSpeed *= -1;
        _position.x += _moveSpeed;
      }
      //\u79fb\u52d5\u3067\u304d\u308b\u30d5\u30ec\u30fc\u30e0\u6570\u304c\uff10\u306b\u306a\u3063\u305f\u3089\u3001\u3082\u3046\u4e00\u5ea6\u30e9\u30f3\u30c0\u30e0\u3067\u79fb\u52d5\u30b9\u30d4\u30fc\u30c9\u3068\u30d5\u30ec\u30fc\u30e0\u6570\u3092\u6c7a\u3081\u308b
      _moveFrame--;
      if(_moveFrame < 0){
        _moveSpeed = (int)random(-MOVE_SPEED_MAX, MOVE_SPEED_MAX);
        _moveFrame = (int)random(MOVE_FRAME_MIN, MOVE_FRAME_MAX);
      }
      break;
    case FLY_STATE:
      //\u4e0a\u65b9\u3078\u79fb\u52d5
      _position.y -= FLY_SPEED;
      break;
    }
    this.draw();
    super.draw();
  }
  
  public void draw(){
    //fill(_myColor);
    //rect(_position.x, _position.y, MY_WIDTH, MY_HEIGHT);
  }
  
  public int getStatus(){
    return _moveState;
  }
  
  //\u30ab\u30e9\u30fc\u30ca\u30f3\u30d0\u30fc\u306e\u30b2\u30c3\u30bf\u30fc
  public int getColorNumber(){
    return _colorNumber;
  }
  
  //\u98db\u3076\u51e6\u7406\u3092on\u306b\u3059\u308b
  public void flyAway(){
    _moveState = FLY_STATE;
  }
}
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

  //\u30bf\u30a4\u30c8\u30eb\u753b\u9762\u306e\u51e6\u7406
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

  //\u30b2\u30fc\u30e0\u753b\u9762\u306e\u5909\u6570\u521d\u671f\u5316
  public void initializeGameScene() {
    //\u30bf\u30a4\u30e0\u5909\u6570\u306e\u521d\u671f\u5316
    _gameTime = GAME_TIME_MAX;
    _gameFrameCounter = 0;
    
    //\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u306e\u521d\u671f\u5316
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
    //\u52d5\u304b\u306a\u3044\u30d6\u30ed\u30c3\u30af\u306e\u4f4d\u7f6e\u3092\u30b7\u30e3\u30c3\u30d5\u30eb\u3059\u308b
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
    _drink = new Drink( this, width * 1.1f, height * 1.1f, _drinkImage );
    _dona = new Dona( this, width - 45, height - 45, _donaImage );
  }

  public void playGameScene() {
    image(_polis, 10, height - 60 );
    //\u6642\u9593\u306e\u8a08\u7b97\u3068\u8868\u793a
    _gameFrameCounter++;
    if (_gameFrameCounter >= 60) {
      _gameFrameCounter = 0;
      _gameTime--;
    }
    fill(0);
    textSize(20);
    text("Time: " + _gameTime, width - 100, 50);
    //\u30bf\u30a4\u30e0\u30aa\u30fc\u30d0\u30fc\u51e6\u7406
    if (_gameTime <= 0) {
      _sceneState = OVER_SCENE;
    }
    _drink.update();
    //\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u306e\u66f4\u65b0\u51e6\u7406
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

  //\u30b2\u30fc\u30e0\u30aa\u30fc\u30d0\u30fc\u753b\u9762\u306e\u51e6\u7406
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

  //\u30b2\u30fc\u30e0\u30af\u30ea\u30a2\u30fc\u753b\u9762\u306e\u51e6\u7406
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
  
  public void update(){
    
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
    //println(""+ _state + ", " + _currentState);
    
    super.draw();
  }
  
  public void draw(){
  
  }
  
}
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
    //\u5909\u6570\u306e\u521d\u671f\u5316
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
      //X\u5ea7\u6a19\u3092\u30e9\u30f3\u30c0\u30e0\u306b\u79fb\u52d5\u3002\u58c1\u306b\u3076\u3064\u304b\u3063\u305f\u3089\u53cd\u8ee2
      _position.x += _moveSpeed;
      if (_position.x <= 0 || _position.x >= width) {
        _moveSpeed *= -1;
        _position.x += _moveSpeed;
      }
      //\u79fb\u52d5\u3067\u304d\u308b\u30d5\u30ec\u30fc\u30e0\u6570\u304c\uff10\u306b\u306a\u3063\u305f\u3089\u3001\u3082\u3046\u4e00\u5ea6\u30e9\u30f3\u30c0\u30e0\u3067\u79fb\u52d5\u30b9\u30d4\u30fc\u30c9\u3068\u30d5\u30ec\u30fc\u30e0\u6570\u3092\u6c7a\u3081\u308b
      _moveFrame--;
      if (_moveFrame < 0) {
        _moveSpeed = (int)random(-MOVE_SPEED_MAX, MOVE_SPEED_MAX);
        _moveFrame = (int)random(MOVE_FRAME_MIN, MOVE_FRAME_MAX);
      }
      break;
    case FLY_STATE:
      //\u4e0a\u65b9\u3078\u79fb\u52d5
      _position.y -= FLY_SPEED;
      break;
    }
    for (int i = 0; i < _theParent._playerCharacter.length; i++) {
      if (hitTest(this, _theParent._playerCharacter[i], 30)) {
        //\u8272\u304c\u540c\u3058\u3060\u3063\u305f\u5834\u5408\u3001\u7684\u30d6\u30ed\u30c3\u30af\u304c\u98db\u3076
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

  //\u30ab\u30e9\u30fc\u30ca\u30f3\u30d0\u30fc\u306e\u30b2\u30c3\u30bf\u30fc
  public int getColorNumber() {
    return _colorNumber;
  }

  //\u98db\u3076\u51e6\u7406\u3092on\u306b\u3059\u308b
  public void flyAway() {
    _moveState = FLY_STATE;
  }
}

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
    _size         = 65.0f;
    _acceleration = 0.1f;
    _power        = 1.5f;
    _count        = 0;
  }
  
  public void update(){
    if( (_position.x < 0 && _count > COUNT_MAX) || (_position.x > width && _count > COUNT_MAX) ){
      _power       *= -1.0f;
      _acceleration = 0.1f;
      _count        = 0;
    }
    
    if(_count <= COUNT_MAX){
      _count++;
    }
    
    _acceleration *= 1.009f;
    _position.x   += ( _power * _acceleration);   
    
    super.draw();
  }
  
  public void draw(){
  }
  
}
class Pig extends BaseCharacter {
  
  private float _speedX, _speedY;
  private float _keepSize;
  
  Pig(Game parent, float x, float y, PImage cImage){
    super(parent, x, y, cImage);
    _myColor = color(255, 255, 255);
    _speedX = random(-5, 5);
    _speedY = random(-5, 5);
    _size = 50;
    _keepSize = _size;
  }
  
  public void update(){
    if(_position.x < 0 || _position.x > width){
      _speedX *= -1;
      _speedX *= 1.1f;
      _size *= 1.1f;
    }
    if(_position.y < 0 || _position.y > height){
      _speedY *= -1;
      _speedY *= 1.1f;
      _size *= 1.1f;
    }
    _position.x += _speedX;
    _position.y += _speedY;
    super.draw();
  }
  
  public void draw(){
  
  }
  
}
class PlayerCharacter extends BaseCharacter {
  //----Constant-----
  //static final float MY_WIDTH = 20;
  //static final float MY_HEIGHT = 40;
  static final int STOP_STATE = 0;
  static final int MOVE_STATE = 1;
  static final int SHOT_STATE = 2;
  static final int SHOT_SPEED = 15;

  //----Field----
  private int _colorNumber;
  //private color _myColor;
  private int _keepColor;
  private int _moveState;
  private boolean _press;
  private float _memoryPositionX, _memoryPositionY;

  public PlayerCharacter(Game parent, float x, float y, int colorNumber, PImage cImage) {
    super(parent, x, y, cImage);
    _colorNumber = colorNumber;
    _myColor = assignColor(colorNumber);
    _moveState = STOP_STATE;
    _press = false;
    _memoryPositionX = _position.x;
    _memoryPositionY = _position.y;
    _keepColor = _myColor;
  }
  
  
  public int getMoveState(){
    return _moveState;
  }

  public void update() {
    Game theParent = (Game)_theParent;
    switch(_moveState) {
    case STOP_STATE:
      _myColor = _keepColor; 
      //if (mouseReleaseMoment()) {
        //\u30de\u30a6\u30b9\u304c\u62bc\u3055\u308c\u305f\u77ac\u9593\u52d5\u304f\u72b6\u614b\u3078\u9077\u79fb
        //if(_position.x + MY_WIDTH / 2 >= mouseX && _position.x - MY_WIDTH / 2 <= mouseX){
        //if(_position.y + MY_HEIGHT / 2 >= mouseY && _position.y - MY_HEIGHT / 2 <= mouseY){
        if (_position.x + _size / 2 >= mouseX && _position.x - _size / 2 <= mouseX) {
          if (_position.y + _size / 2 >= mouseY && _position.y - _size / 2 <= mouseY) {
            if (mouseReleaseMoment()) {
              _moveState = MOVE_STATE;
              _myColor = _keepColor;
              _theParent._hand.setState(1);
            }
            _myColor = color(100, 100, 100);
          }
        }
      //}
      //\u521d\u671f\u4f4d\u7f6e\u306b\u79fb\u52d5
      _position.x = _memoryPositionX;
      _position.y = _memoryPositionY;
      break;
    case MOVE_STATE:
      //\u4f4d\u7f6e\u3092\u30de\u30a6\u30b9\u306e\u4f4d\u7f6e\u306b\u540c\u671f
      _position.x = mouseX;
      //\u30de\u30a6\u30b9\u304c\u62bc\u3055\u308c\u305f\u77ac\u9593\u52d5\u304b\u306a\u3044\u72b6\u614b\u3078\u9077\u79fb
      if (mouseReleaseMoment()) {
        _moveState = SHOT_STATE;
        _theParent._hand.setState(0);
      }
      break;
    case SHOT_STATE:
      //y\u5ea7\u6a19\u3092\u6e1b\u7b97\u3057\u3066\u3001\u98db\u3093\u3067\u3044\u308b\u3088\u3046\u306b\u898b\u305b\u308b
      _position.y -= SHOT_SPEED;
      if (_position.y <= 0) {
        playSound(0);
        theParent._dona._alive = true;
        _moveState = STOP_STATE;
      }

      //\u3059\u3079\u3066\u306e\u7684\u30d6\u30ed\u30c3\u30af\u3068\u306e\u5f53\u305f\u308a\u5224\u5b9a
      for (int i = 0; i < _theParent._enemyCharacter.length; i++) {
        if (hitTest(this, _theParent._enemyCharacter[i], 30)) {
          //\u8272\u304c\u540c\u3058\u3060\u3063\u305f\u5834\u5408\u3001\u7684\u30d6\u30ed\u30c3\u30af\u304c\u98db\u3076
          if (_theParent._enemyCharacter[i].getColorNumber() == _colorNumber) {
            _theParent._enemyCharacter[i].flyAway();
            playSound(1);
            _moveState = STOP_STATE;
          }
        }
      }
      break;
    }
    this.draw();
    super.draw();
  }

  public void draw() {
    //fill(_myColor);
    //rect(_position.x, _position.y, MY_WIDTH, MY_HEIGHT);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Relay" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
