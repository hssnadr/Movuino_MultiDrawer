public class Drawer {
  public float scale = 10.0f;
  
  private Movuino _movuino;
  private Thread _movuinoThread;
  private String _ip = "127.0.0.1";
  private int _portIn = 3400;
  private int _portOut = 3401;

  private MovingMean _meanX = new MovingMean(30);
  private MovingMean _meanY = new MovingMean(30);
  private BezierShape _shape = new BezierShape();

  private long _timer0;

  //---------------------------
  //------ CONSTRUCTORS -------
  //---------------------------
  
  public void Drawer() {
    println(this._ip, this._portIn, this._portOut);
  }
  
  public void Drawer(int portIn_, int portOut_) {
    this._portIn = portIn_;
    this._portOut = portOut_;
    println(this._ip, this._portIn, this._portOut);
  }
  
  public void Drawer(String ip_, int portIn_, int portOut_) {
    this._ip = ip_;
    this._portIn = portIn_;
    this._portOut = portOut_;
    println(this._ip, this._portIn, this._portOut);
  }
  
  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void begin() {
    this._movuino = new Movuino(this._ip, this._portIn, this._portOut);
    this._movuinoThread = new Thread(this._movuino);
    this._movuinoThread.start();
    this._movuino.printRawDataCollect();

    this._timer0 = millis();
  }

  public void update() {
    if (millis()-timer0 > 40) {
      this._timer0 = millis();

      // 1 - Get point coordinates
      float x_ = width * (0.5f + this._movuino.ax / this.scale);
      float y_ = height * (0.5f + this._movuino.ay / this.scale);

      // 2 - Process point
      this._meanX.pushData(x_);
      this._meanY.pushData(y_);
      
      // 3 - push value to shape
      this._shape.pushPoint(this._meanX.getSmooth(), this._meanY.getSmooth());
    }
  }
}
