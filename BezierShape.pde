public class BezierShape {
  private int _N = 20;
  private ArrayList<PVector> _points = new ArrayList<>();
  private ArrayList<PVector> _tangents = new ArrayList<>();
  private boolean _isSymH = false;
  private boolean _isSymV = false;

  // style
  private float _pointSize = 10f;
  private color _pointColor = #FFFFFF;
  private float _strokeWeight = 2f;
  private color _strokeColor = #FFFFFF;
  private color _fillColor = 72;

  private boolean _isTangent = false; // for debug

  public BezierShape(int n_) {
    this._N = n_;
  }

  //---------------------------
  //--------- SETTERS ---------
  //---------------------------

  public void setLength(int n_) {
    this._N = n_;
  }

  public void setHorizontalSym(boolean isSymH_) {
    this._isSymH = isSymH_;
  }

  public void setVerticalSym(boolean isSymV_) {
    this._isSymV = isSymV_;
  }
  
  public void setPointSize(float pointS_) {
    this._pointSize = pointS_;
  }
  
  public void setStrokeWeight(float strokeW_) {
    this._strokeWeight = strokeW_;
  }
  
  public void setStrokeColor(color strokeC_) {
    this._strokeColor = strokeC_ != -1 ? strokeC_ : this._strokeColor;
  }
  
  public void setFillColor(color fillC_) {
    this._fillColor = fillC_ != -1 ? fillC_ : this._fillColor;
  }
  
  public void setPointColor(color pointC_) {
    this._pointColor = pointC_ != -1 ? pointC_ : this._pointColor;
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void pushPoint(float x, float y) {
    if (x != 0.0 && y != 0.0) { // avoid first point
      // 1 - add new values
      PVector curPos_ = new PVector(x, y);
      // this._points.get(_curIndex] = curPos_;
      this._points.add(curPos_);

      // 2 - remove older _dataCollection from the list
      while (this._points.size() > this._N) {
        this._points.remove(0);
      }
    }
  }

  public void drawPoints() {
    // 1 - style points
    strokeWeight(this._pointSize);
    stroke(this._pointColor);

    // 2 - draw points
    for (int i = 0; i < this._points.size(); i++) {
      point(this._points.get(i).x, this._points.get(i).y);

      // symetrical
      if (this._isSymH) {
        point(width - this._points.get(i).x, this._points.get(i).y);
      }
      if (this._isSymV) {
        point(this._points.get(i).x, height - this._points.get(i).y);
        if (this._isSymH) {
          point(width - this._points.get(i).x, height - this._points.get(i).y);
        }
      }
    }
  }

  public void drawLines() {
    // 1 - style lines
    strokeWeight(this._strokeWeight);
    stroke(this._strokeColor);
    fill(this._fillColor);
    
    println(this._strokeColor);

    // 2 - draw lines
    for (int i = 0; i < this._points.size(); i++) {
      // Points
      PVector p0_ = this._points.get(i).copy();           // first point
      int j = i+1 < this._points.size() ? i+1 : 0; // index of second point
      PVector p1_ = this._points.get(j).copy();           // second point

      line(p0_.x, p0_.y, p1_.x, p1_.y);

      // symetrical
      if (this._isSymH) {
        line(width - p0_.x, p0_.y, width - p1_.x, p1_.y);
      }
      if (this._isSymV) {
        line(p0_.x, height - p0_.y, p1_.x, height - p1_.y);
        if (this._isSymH) {
          line(width - p0_.x, height - p0_.y, width - p1_.x, height - p1_.y);
        }
      }
    }
  }

  public void drawBeziers() {
    // 1 - style beziers
    strokeWeight(this._strokeWeight);
    stroke(this._strokeColor);
    fill(this._fillColor);

    // 2 - draw beziers
    if (this._points.size() > 0) {
      // Compute tangents
      this._tangents = new ArrayList<>(); // reset (use .removeAll() ?)
      for (int i = 0; i < this._points.size(); i++) {
        PVector prevPoint_ = this._points.get(i > 0 ? i-1 : this._points.size()-1).copy();
        PVector nextPoint_ = this._points.get(i+1 < this._points.size() ? i+1 : 0).copy();
        this._tangents.add(nextPoint_.sub(prevPoint_));
      }

      // Draw curves
      for (int i = 0; i < this._points.size(); i++) {
        // Points
        PVector p0_ = this._points.get(i).copy();           // first point
        int j = i+1 < this._points.size() ? i+1 : 0; // index of second point
        PVector p1_ = this._points.get(j).copy();           // second point

        // Anchor points
        float mag_ = dist (p0_.x, p0_.y, p1_.x, p1_.y);
        mag_ /= 2.0f;

        PVector anchor0_ = p0_.copy().add(this._tangents.get(i).setMag(mag_));
        PVector anchor1_ = p1_.copy().sub(this._tangents.get(j).setMag(mag_));

        // for debug only
        if (_isTangent) {
          stroke(0, 255, 0);
          line(this._points.get(i).x, this._points.get(i).y, anchor0_.x, anchor0_.y);
          stroke(0, 0, 255);
          line(anchor1_.x, anchor1_.y, this._points.get(j).x, this._points.get(j).y);
        }

        // Draw bezier
        bezier(this._points.get(i).x, this._points.get(i).y, anchor0_.x, anchor0_.y, anchor1_.x, anchor1_.y, this._points.get(j).x, this._points.get(j).y);

        // symetrical
        if (this._isSymH) {
          bezier(width - this._points.get(i).x, this._points.get(i).y, width - anchor0_.x, anchor0_.y, width - anchor1_.x, anchor1_.y, width - this._points.get(j).x, this._points.get(j).y);
        }
        if (this._isSymV) {
          bezier(this._points.get(i).x, height - this._points.get(i).y, anchor0_.x, height - anchor0_.y, anchor1_.x, height - anchor1_.y, this._points.get(j).x, height - this._points.get(j).y);
          if (this._isSymH) {
            bezier(width - this._points.get(i).x, height - this._points.get(i).y, width - anchor0_.x, height - anchor0_.y, width - anchor1_.x, height - anchor1_.y, width - this._points.get(j).x, height - this._points.get(j).y);
          }
        }
      }
    }
  }
}
