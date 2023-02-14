public class Drawer {
  // OSC parameters
  private boolean _isMouse = false;
  private float _maxRatio = 30;
  private float _scale = 1.0f;
  private float _pointSize = 10.0f;
  private float _strokeWeight = 1.0f;
  private boolean _isBeziers = true;
  private boolean _isLines = false;
  private boolean _isPoints = true;

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
  private Shape _shape = new Shape(20);

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
    this._shape.update();
    if (millis() - this._timer0 > 40) {
      //---------------------------------
      //---------- UPDATE OSC -----------
      //---------------------------------

      if (this._isOSC) {
        // data points
        this._shape.setLength(this._osc.getLength() != -1 ? this._osc.getLength() : 20);
        this._meanX.setSmooth(this._osc.getSmooth() != -1 ? this._osc.getSmooth() : 1);
        this._meanY.setSmooth(this._osc.getSmooth() != -1 ? this._osc.getSmooth() : 1);

        // render
        this._scale = this._osc.getScale() != -1f ? this._osc.getScale() : this._scale;
        this._isMouse = this._osc.isMouse();

        // shape
        this._shape.setPointSize(this._osc.getPointSize() != -1f ? this._osc.getPointSize() : this._pointSize);
        this._shape.setStrokeWeight(this._osc.getStrokeWeight() != -1f ? this._osc.getStrokeWeight() : this._strokeWeight);
        this._shape.setHorizontalSym(this._osc.isSymH());
        this._shape.setVerticalSym(this._osc.isSymV());

        // colors
        this._shape.setPointColor(this._osc.getPointColor());
        this._shape.isStroke(this._osc.isStroke());
        this._shape.setStrokeColor(this._osc.getStrokeColor());
        this._shape.isFill(this._osc.isFill());
        this._shape.setFillColor(this._osc.getFillColor());

        // display mode
        this._isPoints = this._osc.isPoints();
        this._isLines = this._osc.isLines();
        this._isBeziers = this._osc.isCurves();
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

      // println(dist(x_, y_, this._meanX.getSmooth(), this._meanY.getSmooth()));
      if (Float.isNaN(this._meanX.getSmooth()) && Float.isNaN(this._meanY.getSmooth())) {
        pushPoint(x_, y_);
      } else {
        if (dist(x_, y_, this._meanX.getSmooth(), this._meanY.getSmooth()) > 10) {
          pushPoint(x_, y_);
        }
      }
    }
  }

  private void pushPoint(float x_, float y_) {
    // 1 - Process point
    this._meanX.pushData(x_);
    this._meanY.pushData(y_);

    // 2 - push value to shape
    this._shape.pushPoint(this._meanX.getSmooth(), this._meanY.getSmooth());
  }

  public void draw() {
    // if (this._isBeziers)
    // this._shape.drawCurveShape();

    if (this._isBeziers)
      this._shape.drawBeziers();
    if (this._isLines)
      this._shape.drawLines();
    if (this._isPoints)
      this._shape.drawPoints();
  }
}
