public class Drawer {
  // Publid parameters
  public boolean isMouse = false;

  // OSC parameters
  private int _smooth = 10; // default = no smooth
  private float _scale = 10.0f;
  private boolean _isBeziers = true;
  private boolean _isLines = false;
  private boolean _isPoints = false;

  // Sensor
  private Movuino _movuino;
  private Thread _movuinoThread;
  private String _ip = "127.0.0.1";
  private int _portIn = 3400;
  private int _portOut = 3401;

  // Moving mean
  private MovingMean _meanX = new MovingMean(_smooth);
  private MovingMean _meanY = new MovingMean(_smooth);
  private BezierShape _shape = new BezierShape();

  // Extra
  private long _timer0;

  //---------------------------
  //------ CONSTRUCTORS -------
  //---------------------------

  public Drawer() {
    println(this._ip, this._portIn, this._portOut);
  }

  public Drawer(int portIn_, int portOut_) {
    this._portIn = portIn_;
    this._portOut = portOut_;
    println(this._ip, this._portIn, this._portOut);
  }

  public Drawer(String ip_, int portIn_, int portOut_) {
    this._ip = ip_;
    this._portIn = portIn_;
    this._portOut = portOut_;
    println(this._ip, this._portIn, this._portOut);
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void begin() {
    if (!isMouse) {
      this._movuino = new Movuino(this._ip, this._portIn, this._portOut);
      this._movuinoThread = new Thread(this._movuino);
      this._movuinoThread.start();
      this._movuino.printRawDataCollect();
    }
    this._timer0 = millis();
  }

  public void update() {
    if (millis() - this._timer0 > 40) {
      // 0 - Reset timer
      this._timer0 = millis();

      // 1 - Get point coordinates
      float x_;
      float y_;
      if (isMouse) {
        x_ = mouseX; // mouse control
        y_ = mouseY;
      } else {
        x_ = width * (0.5f + this._movuino.ax / this._scale); // sensor control
        y_ = height * (0.5f + this._movuino.ay / this._scale);
      }

      // 2 - Process point
      this._meanX.pushData(x_);
      this._meanY.pushData(y_);

      // 3 - push value to shape
      this._shape.pushPoint(this._meanX.getSmooth(), this._meanY.getSmooth());
    }
  }

  public void draw() {
    if (this._isBeziers)
      this._shape.drawBeziers();
    if (this._isLines)
      this._shape.drawLines();
    if (this._isPoints)
      this._shape.drawPoints();
  }
}
