public class BezierShape {
  private int N = 20;
  private PVector points[] = new PVector[N]; // path point
  private PVector tangents[] = new PVector[N]; // (forward) tangent direction for each points
  private int _curIndex = 0;
  private int _maxIndex = 0;

  private boolean _isTangent = false;

  public BezierShape(int n_) {
    this.N = n_;
  }

  //---------------------------
  //--------- SETTERS ---------
  //---------------------------

  public void setLength(int n_) {
    this.N = n_;
    /*
    this.points = new PVector[this.N];
    this.tangents = new PVector[this.N];
    this._curIndex = 0;
    this._maxIndex = 0;
    */
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------

  public void begin() {
    stroke(255);
    strokeWeight(4);
  }

  public void pushPoint(float x, float y) {
    if (x != 0.0 && y != 0.0) {
      PVector curPos_ = new PVector(x, y);
      points[_curIndex] = curPos_;
      _curIndex++;
      _curIndex = _curIndex % N;
      _maxIndex = max(_curIndex, _maxIndex);
    }
  }

  public void drawPoints() {
    for (int i = 0; i < _maxIndex; i++) {
      strokeWeight(10);
      point(points[i].x, points[i].y);

      // symetrical
      point(width - points[i].x, points[i].y);
      point(points[i].x, height - points[i].y);
      point(width - points[i].x, height - points[i].y);
    }
  }

  public void drawLines() {
    for (int i = 0; i < _maxIndex; i++) {
      // Points
      PVector p0_ = points[i].copy();           // first point
      int j = i+1 < _maxIndex ? i+1 : 0; // index of second point
      PVector p1_ = points[j].copy();           // second point

      strokeWeight(1);
      line(p0_.x, p0_.y, p1_.x, p1_.y);

      // symetrical
      line(width - p0_.x, p0_.y, width - p1_.x, p1_.y);
      line(p0_.x, height - p0_.y, p1_.x, height - p1_.y);
      line(width - p0_.x, height - p0_.y, width - p1_.x, height - p1_.y);
    }
  }

  public void drawBeziers() {
    if (_maxIndex > 0) {
      // Compute tangents
      for (int i = 0; i < _maxIndex; i++) {
        PVector prevPoint_ = points[i > 0 ? i-1 : _maxIndex-1].copy();
        PVector nextPoint_ = points[i+1 < _maxIndex ? i+1 : 0].copy();
        tangents[i] = nextPoint_.sub(prevPoint_);
      }

      // Draw curves
      for (int i = 0; i < _maxIndex; i++) {
        // Points
        PVector p0_ = points[i].copy();           // first point
        int j = i+1 < _maxIndex ? i+1 : 0; // index of second point
        PVector p1_ = points[j].copy();           // second point

        // Anchor points
        float mag_ = dist (p0_.x, p0_.y, p1_.x, p1_.y);
        mag_ /= 2.0f;

        PVector anchor0_ = p0_.copy().add(tangents[i].setMag(mag_));
        PVector anchor1_ = p1_.copy().sub(tangents[j].setMag(mag_));

        if (_isTangent) {
          stroke(0, 255, 0);
          line(points[i].x, points[i].y, anchor0_.x, anchor0_.y);
          stroke(0, 0, 255);
          line(anchor1_.x, anchor1_.y, points[j].x, points[j].y);
        }

        // Draw bezier
        stroke(255);
        strokeWeight(2);
        fill(255);
        bezier(points[i].x, points[i].y, anchor0_.x, anchor0_.y, anchor1_.x, anchor1_.y, points[j].x, points[j].y);

        // symetrical
        bezier(width - points[i].x, points[i].y, width - anchor0_.x, anchor0_.y, width - anchor1_.x, anchor1_.y, width - points[j].x, points[j].y);
        bezier(points[i].x, height - points[i].y, anchor0_.x, height - anchor0_.y, anchor1_.x, height - anchor1_.y, points[j].x, height - points[j].y);
        bezier(width - points[i].x, height - points[i].y, width - anchor0_.x, height - anchor0_.y, width - anchor1_.x, height - anchor1_.y, width - points[j].x, height - points[j].y);
      }
    }
  }
}
