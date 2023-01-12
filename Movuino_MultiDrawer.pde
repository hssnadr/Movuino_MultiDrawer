Drawer drawer0 = new Drawer();
Drawer drawer1 = new Drawer(4000, 4001);
// Drawer drawer2 = new Drawer(4100, 4101);
// Drawer drawer3 = new Drawer(4200, 4201);

void setup() {
  size(720, 720);

  drawer0.isMouse(true);
  drawer0.begin();

  drawer1.begin();
  drawer1.startOSC();

  // drawer2.begin();
  // drawer2.startOSC();
  
  // drawer3.begin();
  // drawer3.startOSC();
}

void draw() {
  background(51);

  drawer0.update();
  drawer1.update();
  // drawer2.update();
  // drawer3.update();

  // drawer0.draw();
  drawer1.draw();
  // drawer2.draw();
  // drawer3.draw();
}
