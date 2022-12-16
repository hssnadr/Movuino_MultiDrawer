int num = 10;
float mx[] = new float[num];
float my[] = new float[num];

PVector points[] = new PVector[num]; // path point
PVector tangents[] = new PVector[num]; // (forward) tangent direction for each points

long timer0;
int _curIndex = 6; // 0;
int _maxIndex = 0;

void setup() {
  size(640, 360);
  stroke(255);
  strokeWeight(4);
  noFill();

  for (int i=0; i< num; i++) {
    mx[i] = random(width);
    my[i] = random(height);
    
    points[i] = new PVector(mx[i], my[i]);
    println(i, points[i]);
  }

  timer0 = millis();
  
  // drawX();
}

void draw() {
  background(51);

  if (millis()-timer0 > 200) {
    timer0 = millis();

    if (mouseX != 0.0 && mouseY != 0.0) {
      _curIndex++;
      _curIndex = _curIndex % num;
      _maxIndex = max(_curIndex, _maxIndex);
      // mx[_curIndex] = mouseX;
      // my[_curIndex] = mouseY;
      points[_curIndex] = new PVector(mouseX, mouseY);
    }
  }
  
  println(_maxIndex);

  // _maxIndex = _curIndex; // FOR STATIC TEST

  println("------------");
  if (_maxIndex > 0) {
    // Compute tangents
    for (int i = 0; i < _maxIndex; i++) {
      PVector prevPoint_ = points[i > 0 ? i-1 : _maxIndex-1].copy();
      PVector nextPoint_ = points[i+1 < _maxIndex ? i+1 : 0].copy();
      tangents[i] = nextPoint_.sub(prevPoint_);
      tangents[i].setMag(70);
    }

    // Draw curves
    for (int i = 0; i < _maxIndex; i++) {
      // Points
      PVector p0_ = points[i].copy();           // first point
      int j = i+1 < _maxIndex ? i+1 : 0; // index of second point
      PVector p1_ = points[j].copy();           // second point
      
      // Straight paths
      stroke(255,0,0);
      strokeWeight(1);
      line(p0_.x, p0_.y, p1_.x, p1_.y);
      
      // Anchor points
      stroke(0,255,0);
      PVector anchor0_ = p0_.copy().add(tangents[i]);
      line(points[i].x, points[i].y,anchor0_.x, anchor0_.y);
      
      stroke(0,0,255);
      PVector anchor1_ = p1_.copy().sub(tangents[j]);
      line(anchor1_.x, anchor1_.y, points[j].x, points[j].y);
      
      stroke(255);
      strokeWeight(3);
      bezier(points[i].x, points[i].y,anchor0_.x, anchor0_.y, anchor1_.x, anchor1_.y, points[j].x, points[j].y);
    }
  }
}
