// Drawer drawer0 = new Drawer();
Drawer drawer1 = new Drawer(4000, 4001);
Drawer drawer2 = new Drawer(4100, 4101);
Drawer drawer3 = new Drawer(4200, 4201);
Drawer drawer4 = new Drawer(4300, 4301);

String fileBackground = "background.jpg";
PImage imgBackground;

void setup() {
  size(1080, 720);
  imgBackground = loadImage(fileBackground);
  imgBackground.resize(width, height);

  // blendMode(MULTIPLY);
  strokeJoin(ROUND);

  // drawer0.isMouse(true);
  // drawer0.begin();

  drawer1.begin();
  drawer1.startOSC();

  drawer2.begin();
  drawer2.startOSC();

  drawer3.begin();
  drawer3.startOSC();

  drawer4.begin();
  drawer4.startOSC();
}

void draw() {
  // background(51); 
  background(imgBackground);

  // drawer0.update();
  drawer1.update();
  drawer2.update();
  drawer3.update();
  drawer4.update();

  // drawer0.draw();
  drawer1.draw();
  drawer2.draw();
  drawer3.draw();
  drawer4.draw();
}
