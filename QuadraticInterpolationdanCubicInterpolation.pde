float xStart = 150; 
float xEnd = 650;   
float t = 0;     
float speed = 0.008;

void setup() {
  size(800, 500);
  noStroke();
}

void draw() {
  background(25);

  fill(255);
  textSize(18);
  textAlign(CENTER);
  text("Perbandingan Teknik Interpolasi (Easing)", width/2, 40);

  float fLinear = t;
  float xLinear = lerp(xStart, xEnd, fLinear);

  drawTrack(120, "1. Linear Interpolation (Konstan)", color(255, 100, 100));
  fill(255, 100, 100);
  ellipse(xLinear, 120, 35, 35);


  float fQuad;
  if (t < 0.5) {
    fQuad = 2 * t * t; // Ease-In
  } else {
    fQuad = -1 + (4 - 2 * t) * t; // Ease-Out
  }
  float xQuad = lerp(xStart, xEnd, fQuad);

  drawTrack(240, "2. Quadratic Interpolation (Ease-In-Out)", color(100, 255, 100));
  fill(100, 255, 100);
  ellipse(xQuad, 240, 35, 35);


  float fCubic;
  if (t < 0.5) {
    fCubic = 4 * pow(t, 3); // Ease-In
  } else {
    fCubic = 1 - pow(-2 * t + 2, 3) / 2; // Ease-Out
  }
  float xCubic = lerp(xStart, xEnd, fCubic);

  drawTrack(360, "3. Cubic Interpolation (Ease-In-Out)", color(100, 180, 255));
  fill(100, 180, 255);
  ellipse(xCubic, 360, 35, 35);


  t += speed;
  if (t > 1.0) {
    t = 0; 
  }
}

void drawTrack(float y, String label, color col) {
  stroke(60);
  strokeWeight(4);
  line(xStart, y, xEnd, y);
  
  fill(150);
  noStroke();
  ellipse(xStart, y, 8, 8);
  ellipse(xEnd, y, 8, 8);

  fill(col);
  textSize(14);
  textAlign(LEFT, CENTER);
  text(label, 30, y - 30);
}
