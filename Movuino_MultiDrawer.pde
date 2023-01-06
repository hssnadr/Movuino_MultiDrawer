// Shape controller 0
BezierShape _shape0 = new BezierShape();

// Shape controller 1
Movuino movuino1;
Thread movuinoThread1;
MovingMean _meanx1 = new MovingMean(30);
MovingMean _meany1 = new MovingMean(30);
BezierShape _shape1 = new BezierShape();

// Shape controller 2
Movuino movuino2;
Thread movuinoThread2;
MovingMean _meanx2 = new MovingMean(20);
MovingMean _meany2 = new MovingMean(20);
BezierShape _shape2 = new BezierShape();

long timer0;

void setup() {
  size(1200, 720);

  // MOVUINO
  // callMovuino("127.0.0.1", 7400, 7401);

  // Controller 1
  movuino1 = new Movuino("127.0.0.1", 7400, 7401);
  movuinoThread1 = new Thread(movuino1);
  movuinoThread1.start();
  movuino1.printRawDataCollect();
  
  // Controller 2
  movuino2 = new Movuino("127.0.0.1", 3000, 3001);
  movuinoThread2 = new Thread(movuino2);
  movuinoThread2.start();
  movuino2.printRawDataCollect();

  // SHAPES
  _shape1.begin();
  // _shape2.setLength(30);
  _shape2.begin();

  timer0 = millis();
}

void draw() {
  background(51);

  if (millis()-timer0 > 40) {
    timer0 = millis();
    updateShape0();
    updateShape1();
    updateShape2();
  }

  // Draw shape 0
  _shape0.drawPoints();
  _shape0.drawLines();
  // _shape0.drawBeziers();
  
  // Draw shape 1
  _shape1.drawBeziers();
  
  // Draw shape 1
  _shape2.drawBeziers();
  // _shape2.drawPoints();
  // _shape2.drawLines();
}

void updateShape0() {
  _shape0.pushPoint(mouseX, mouseY);
}

void updateShape1() {
  // 1 - Get point coordinates
  float x_ = width * (0.5f + movuino1.ax / 15.0f);
  float y_ = height * (0.5f + movuino1.ay / 15.0f);

  // 2 - Process point
  _meanx1.pushData(x_);
  _meany1.pushData(y_);

  // 3 - Draw shape
  _shape1.pushPoint(_meanx1.getSmooth(), _meany1.getSmooth());
}

void updateShape2() {
  // 1 - Get point coordinates
  float x_ = width * (0.5f + movuino2.ax / 1.5f);
  float y_ = height * (0.5f + movuino2.ay / 1.5f);

  // 2 - Process point
  _meanx2.pushData(x_);
  _meany2.pushData(y_);

  // 3 - Draw shape
  _shape2.pushPoint(_meanx2.getSmooth(), _meany2.getSmooth());
}
