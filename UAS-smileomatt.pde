
int mouth = 1024;
int eye = 512;
int col = 150;

boolean mclick = false;
boolean eclick = false;
boolean cclick = false;

void setup() {
  size(300, 390);
  smooth();
  background(255);
  colorMode(HSB);
}

void draw() {
  background(255);

  drawSliders();

  strokeWeight(3);

  color c = color(map(col, 0, 1024, 0, 255), 255, 255);
  fill(c);
  ellipse(150, 150, 250, 250);

  fill(255);
  ellipse(120, 140, 60, 60);
  ellipse(180, 140, 60, 60);

  fill(0);
  ellipse(125, 150, 20, 20);
  ellipse(175, 150, 20, 20);

  line(100, 100 + map(eye, 0, 1024, -10, 10),
       140, 100 - map(eye, 0, 1024, -10, 10));

  line(160, 100 - map(eye, 0, 1024, -10, 10),
     200, 100 + map(eye, 0, 1024, -10, 10));

  noFill();
  beginShape();
  curveVertex(100, 200);
  curveVertex(100, 200);
  curveVertex(150, 180 + map(mouth, 0, 1024, 0, 50));
  curveVertex(200, 200);
  curveVertex(200, 200);
  endShape();
}

void drawSliders() {
  fill(0);
  strokeWeight(1);

  rect(20, 315, width-40, 2);
  rect(15 + map(mouth, 0, 1024, 0, width-40), 310, 10, 12);

  rect(20, 345, width-40, 2);
  rect(15 + map(eye, 0, 1024, 0, width-40), 340, 10, 12);

  rect(20, 375, width-40, 2);
  rect(15 + map(col, 0, 1024, 0, width-40), 370, 10, 12);
}

void mousePressed() {
  if (mouseY > 310 && mouseY < 322) {
    mclick = true;
    mouth = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }

  if (mouseY > 340 && mouseY < 352) {
    eclick = true;
    eye = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }

  if (mouseY > 370 && mouseY < 382) {
    cclick = true;
    col = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }
}

void mouseDragged() {
  if (mclick) {
    mouth = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }

  if (eclick) {
    eye = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }

  if (cclick) {
    col = constrain(int(map(mouseX, 20, width-20, 0, 1024)), 0, 1024);
  }
}

void mouseReleased() {
  mclick = false;
  eclick = false;
  cclick = false;
}
