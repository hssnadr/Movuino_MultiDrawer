Drawer drawer0 = new Drawer();
Drawer drawer1 = new Drawer(4000, 4001);
Drawer drawer2 = new Drawer(7400, 7401);

void setup() {
  size(1200, 720);
  
  drawer0.isMouse = true;
  drawer0.begin();
  drawer1.begin();
  drawer2.begin();
}

void draw() {
  background(51);
  drawer0.update();
  drawer1.update();
  drawer2.update();
  
  drawer0.draw();
  drawer1.draw();
  drawer2.draw();
}
