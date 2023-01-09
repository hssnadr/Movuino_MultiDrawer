public class Drawer {
  // OSC parameters
  private boolean _isMouse = false;
  private float _maxRatio = 30;
  private float _scale = 1.0f;
  private boolean _isBeziers = true;
  private boolean _isLines = false;
  private boolean _isPoints = false;

  // Sensor
  private boolean _isOSC = false;
  private OSC _osc;
  private Thread _oscThread;
  private String _ip = "127.0.0.1";
  private int _portIn = 3400;
  private int _portOut = 3401;

  // Moving mean
  private MovingMean _meanX = new MovingMean(1);
  private MovingMean _meanY = new MovingMean(1);
  private BezierShape _shape = new BezierShape(20);

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
  //--------- SETTERS ---------
  //---------------------------

  public void isMouse(boolean isMouse_) {
    this._isMouse = isMouse_;
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void begin() {
    this._timer0 = millis();
  }

  public void startOSC() {
    this._osc = new OSC(this._ip, this._portIn, this._portOut);
    this._oscThread = new Thread(this._osc);
    this._oscThread.start();
    this._osc.printRawDataCollect();
    this._isOSC = true;
  }

  public void update() {
    if (millis() - this._timer0 > 40) {
      //---------------------------------
      //---------- UPDATE OSC -----------
      //---------------------------------

      if (this._isOSC) {
        this._shape.setLength(this._osc.getLength() != -1 ? this._osc.getLength() : 20); // TO FIX
        this._meanX.setSmooth(this._osc.getSmooth() != -1 ? this._osc.getSmooth() : 1);
        this._meanY.setSmooth(this._osc.getSmooth() != -1 ? this._osc.getSmooth() : 1);
        this._scale = this._osc.getScale() != -1f ? this._osc.getScale() : this._scale;
        this._isMouse = this._osc.isMouse();

        // display mode
        // this._isBeziers = true;
        // this._isLines = false;
        // this._isPoints = false;
      }

      //---------------------------------
      //--------- UPDATE SHAPE ----------
      //---------------------------------
      // 0 - Reset timer
      this._timer0 = millis();

      // 1 - Get point coordinates
      float x_;
      float y_;
      if (this._isMouse) {
        x_ = mouseX; // mouse control
        y_ = mouseY;
      } else {
        float ratio_ = 1.0f / (this._maxRatio * this._scale);
        x_ = width * (0.5f + this._osc.getPoint().x * ratio_); // sensor control
        y_ = height * (0.5f + this._osc.getPoint().y * ratio_);
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
