int N = 20;
PVector points[] = new PVector[N]; // path point
PVector tangents[] = new PVector[N]; // (forward) tangent direction for each points

long timer0;
int _curIndex = 0; // N;
int _maxIndex = 0;

void setup() {
  callMovuino("127.0.0.1", 3000, 3001);

  size(1200, 720);
  stroke(255);
  strokeWeight(4);
  noFill();
  fill(255);

  timer0 = millis();

  // STATIC TEST
  if (false) {
    for (int i=0; i< N; i++) {
      points[i] = new PVector(random(20, width-20), random(20, height-20));
      println(i, points[i]);
    }
    _maxIndex = N;
    // drawX();
  }
}

void draw() {
  background(51);

  if (true) {
    if (millis()-timer0 > 40) {
      float valX_ = width * (0.5f + movuino.az / 1.0f) ; // mouseX;
      float valY_ = height * (0.5f + movuino.ax / 1.0f) ; // mouseY;
        
      // float valX_ = mouseX; // width * (0.5f + mouseX / 640.0f) ; // mouseX;
      // float valY_ = mouseY ; //  height * (0.5f + mouseY / 360.0f) ; // mouseY;
      
      timer0 = millis();

      if (valX_ != 0.0 && valY_ != 0.0) {
        PVector curPos_ = new PVector(valX_, valY_);
        // PVector lastPos_ = points[_curIndex > 0 ? _curIndex-1 : _maxIndex-1];
        // if (dist(curPos_.x, curPos_.y, lastPos_.x, lastPos_.y) > 20) {
        points[_curIndex] = curPos_;
        _curIndex++;
        _curIndex = _curIndex % N;
        _maxIndex = max(_curIndex, _maxIndex);
        // }
      }
    }
  }

  // println("------------");
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

      // Straight paths
      stroke(255, 0, 0);
      strokeWeight(1);
      //line(p0_.x, p0_.y, p1_.x, p1_.y);

      // Anchor points
      float mag_ = dist (p0_.x, p0_.y, p1_.x, p1_.y);
      mag_ /= 2.0f;

      stroke(0, 255, 0);
      PVector anchor0_ = p0_.copy().add(tangents[i].setMag(mag_));
      // line(points[i].x, points[i].y, anchor0_.x, anchor0_.y);

      stroke(0, 0, 255);
      PVector anchor1_ = p1_.copy().sub(tangents[j].setMag(mag_));
      // line(anchor1_.x, anchor1_.y, points[j].x, points[j].y);

      // Draw bezier
      stroke(255);
      strokeWeight(2);
      bezier(points[i].x, points[i].y, anchor0_.x, anchor0_.y, anchor1_.x, anchor1_.y, points[j].x, points[j].y);

      strokeWeight(10);
      // point(points[i].x, points[i].y);
    }
  }
}
