import processing.serial.*;
import oscP5.*;
import netP5.*;

public class OSC implements Runnable {
  float[] rawData; // array list to store each data sent from the Movuino. The size of the list correspond to the size of the moving mean
  int nDat = 3; // number of data receive from Movuino (example : N = 6 for Acc X, Y, Z and Gyr X, Y, Z) + 1 ID

  Thread thread;
  // OSC communication parameters
  OscP5 osc;
  NetAddress myOSCLocation;
  int portIn = 7400;
  int portOut = 7401;
  String ip;

  String device;  // type of device (smartphone or movuino)
  int id;      // id of the device

  private PVector _point = new PVector(0.0f, 0.0f, 0.0f);
  private int _length = -1;
  private int _smooth = -1;
  private float _scale = -1f;
  private float _pointSize = -1f;
  private float _strokeWeight = -1f;
  private boolean _isMouse = false;
  private boolean _isSymH = false;
  private boolean _isSymV = false;
  private boolean _isPoints = false;
  private boolean _isLines = false;
  private boolean _isCurves = false;
  private boolean _isStroke = true;
  private color _strokeC = -1;
  private boolean _isFill = false;
  private color _fillC = -1;
  private color _pointC = -1;

  // neopixel movuino
  int red = 255;   // red component for neopixel color
  int green = 255; // green component for neopixel color
  int blue = 255;  // blue component for neopixel color
  private int brightness = 255;

  public OSC(String ip_, int portin_, int portout_) {
    this.ip = ip_;
    this.portIn = portin_;
    this.portOut = portout_;
    osc = new OscP5(this, this.portIn); // this port must be the same than the port on the Movuino
    myOSCLocation = new NetAddress(this.ip, this.portOut);
    NetInfo.print();
    this.rawData = new float[nDat];
  }

  //---------------------------
  //--------- GETTERS ---------
  //---------------------------

  public PVector getPoint() {
    return this._point;
  }

  public int getLength() {
    return this._length;
  }

  public int getSmooth() {
    return this._smooth;
  }

  public float getScale() {
    return this._scale;
  }

  public float getPointSize() {
    return this._pointSize;
  }

  public float getStrokeWeight() {
    return this._strokeWeight;
  }

  public boolean isMouse() {
    return this._isMouse;
  }

  public boolean isSymH() {
    return this._isSymH;
  }

  public boolean isSymV() {
    return this._isSymV;
  }

  public boolean isPoints() {
    return this._isPoints;
  }

  public boolean isLines() {
    return this._isLines;
  }

  public boolean isCurves() {
    return this._isCurves;
  }

  public color getPointColor() {
    return this._pointC;
  }

  public boolean isStroke() {
    return this._isStroke;
  }
  
  public color getStrokeColor() {
    return this._strokeC;
  }
  
  public boolean isFill() {
    return this._isFill;
  }
  
  public color getFillColor() {
    return this._fillC;
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {
    while (true) {
      // update point coordinates
      _point = new PVector(this.rawData[0], this.rawData[1], this.rawData[2]);
      delay(5); // regulation
    }
  }

  public void stop() {
    thread = null;
  }

  //-----------------------------
  //--------- DATA PRINT --------
  //-----------------------------

  void printInfo() {
    println("Device:", this.device);
    println("ID:", this.id);
    println("Coordinates:", _point.x, _point.y, _point.z);
    println("-------------------------");
  }

  void printRawDataCollect() {
    // Print raw data store from the Movuino
    for (int j=0; j < this.nDat; j++) {
      if (this.rawData != null) {
        print(this.rawData[j] + " ");
      }
      if (j==this.nDat-1) {
        println();
      }
    }
  }

  //-----------------------------
  //----- OSC COMMUNICATION -----
  //-----------------------------

  void sendOSC(String addr_, String mess_) {
    OscMessage myOscMessage = new OscMessage("/" + addr_); // create a new OscMessage with an address pattern
    myOscMessage.add(mess_); // add a value to the OscMessage
    osc.send(myOscMessage, myOSCLocation); // send the OscMessage to a remote location specified in myNetAddress
  }

  void oscEvent(OscMessage theOscMessage) {
    println(theOscMessage);
    if (theOscMessage.checkAddrPattern("/drawer/imu")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("fff")) {
        for (int i=0; i<nDat; i++) {
          this.rawData[i] = theOscMessage.get(i).floatValue();
        }
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/length")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._length = theOscMessage.get(0).intValue();
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/smooth")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._smooth = theOscMessage.get(0).intValue();
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/scale")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("f")) {
        this._scale = theOscMessage.get(0).floatValue();
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/pointS")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._pointSize = theOscMessage.get(0).intValue();
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/strokeW")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._strokeWeight = theOscMessage.get(0).intValue();
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/mouse")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isMouse = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/symH")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isSymH = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/symV")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isSymV = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/points")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isPoints = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/lines")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isLines = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/curves")) {
      this.device = "Drawer";
      if (theOscMessage.checkTypetag("i")) {
        this._isCurves = theOscMessage.get(0).intValue() != 0 ? true : false;
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/pointC")) {
      this.device = "Drawer";
      println("OSC receive stroke color"); 
      if (theOscMessage.checkTypetag("ffff")) {
        int r_ = int(255.0 * theOscMessage.get(0).floatValue());
        int g_ = int(255.0 * theOscMessage.get(1).floatValue());
        int b_ = int(255.0 * theOscMessage.get(2).floatValue());
        int a_ = int(255.0 * theOscMessage.get(3).floatValue());
        this._pointC = color(r_,g_,b_,a_);
        println(this._pointC);
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/strokeC")) {
      this.device = "Drawer";
      println("OSC receive stroke color"); 
      if (theOscMessage.checkTypetag("ffff")) {
        int r_ = int(255.0 * theOscMessage.get(0).floatValue());
        int g_ = int(255.0 * theOscMessage.get(1).floatValue());
        int b_ = int(255.0 * theOscMessage.get(2).floatValue());
        int a_ = int(255.0 * theOscMessage.get(3).floatValue());
        this._strokeC = color(r_,g_,b_,a_);
        println(this._strokeC);
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/drawer/fillC")) {
      this.device = "Drawer";
      println("OSC receive stroke color"); 
      if (theOscMessage.checkTypetag("ffff")) {
        int r_ = int(255.0 * theOscMessage.get(0).floatValue());
        int g_ = int(255.0 * theOscMessage.get(1).floatValue());  /// ----------------------
        int b_ = int(255.0 * theOscMessage.get(2).floatValue());
        int a_ = int(255.0 * theOscMessage.get(3).floatValue());
        this._fillC = color(r_,g_,b_,a_);
        println(this._strokeC);
        return;
      }
    }

    //-----------------------------
    //----------- EXTRA -----------
    //-----------------------------

    if (theOscMessage.checkAddrPattern("/movuino")) {
      this.device = "Movuino";
      if (theOscMessage.checkTypetag("sfffffffffii")) {
        this.id = parseInt(theOscMessage.get(0).stringValue());
        for (int i=0; i<nDat; i++) {
          this.rawData[i] = theOscMessage.get(i+1).floatValue();
        }
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/streamo")) {
      this.device = "Smartphone";
      if (theOscMessage.checkTypetag("sfffffffff")) {
        this.id = parseInt(theOscMessage.get(0).stringValue());
        for (int i=0; i<nDat; i++) {
          this.rawData[i] = theOscMessage.get(i+1).floatValue();
        }
        return;
      }
    }
  }

  //-----------------------------
  //---------- NEOPIXEL ---------
  //-----------------------------

  void lightNow(boolean isLit_) {
    // Switch ON/OFF the light
    if (isLit_) {
      this.setNeopix(this.red, this.green, this.blue); // turn on to previous light color
    } else {
      this.setNeopix(0);                               // turn off
    }
  }

  void setBrightness(int bright_) {
    this.brightness = constrain(bright_, 0, 255);     // set new brightness
    this.setNeopix(this.red, this.green, this.blue);  // send to Movuino
  }

  void setNeopix(color color_) {
    setNeopix(red(color_), green(color_), blue(color_));
  }

  void setNeopix(float greyShade_) {
    greyShade_ = constrain(greyShade_, 0, 255);
    setNeopix(greyShade_, greyShade_, greyShade_);
  }

  void setNeopix(float red_, float green_, float blue_) {
    OscMessage myOscMessage = new OscMessage("/neopix"); // create a new OscMessage with an address pattern

    float bright_ = map(this.brightness, 0, 255, 255, 1);

    // Add new color values to message
    myOscMessage.add(int(red_/bright_));
    myOscMessage.add(int(green_/bright_));
    myOscMessage.add(int(blue_/bright_));

    // Send message
    osc.send(myOscMessage, myOSCLocation); // send the OscMessage to a remote location specified in myNetAddress

    // Store new color values
    if (red_ > 0 && green_ > 0 && blue_ > 0) {
      red = int(red_);
      green = int(green_);
      blue = int(blue_);
    }
  }
  // println("### received an osc message. with address pattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
}
