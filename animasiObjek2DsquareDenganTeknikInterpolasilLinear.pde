float[] xCorner = new float[4];
float[] yCorner = new float[4];

color[] colors = new color[4];

int currentCorner = 0;
float t = 0;            
float speed = 0.01;     

void setup() {
  size(600, 600);
  rectMode(CENTER);
  noStroke();

  float margin = 100;
  xCorner[0] = margin;         
  yCorner[0] = margin;
  xCorner[1] = width - margin; 
  yCorner[1] = margin;
  xCorner[2] = width - margin; 
  yCorner[2] = height - margin;
  xCorner[3] = margin;         
  yCorner[3] = height - margin;

  colors[0] = color(255, 0, 0);   
  colors[1] = color(255, 255, 0);  
  colors[2] = color(0, 0, 255); 
  colors[3] = color(0, 255, 0);   
}

void draw() {
  background(30);
  int nextCorner = (currentCorner + 1) % 4;

  float currentX = lerp(xCorner[currentCorner], xCorner[nextCorner], t);
  float currentY = lerp(yCorner[currentCorner], yCorner[nextCorner], t);
  color currentColor = lerpColor(colors[currentCorner], colors[nextCorner], t);

  stroke(80);
  strokeWeight(2);
  line(xCorner[0], yCorner[0], xCorner[1], yCorner[1]);
  line(xCorner[1], yCorner[1], xCorner[2], yCorner[2]);
  line(xCorner[2], yCorner[2], xCorner[3], yCorner[3]);
  line(xCorner[3], yCorner[3], xCorner[0], yCorner[0]);

  noStroke();
  fill(currentColor);
  rect(currentX, currentY, 50, 50);

  t += speed;
  if (t >= 1.0) {
    t = 0;
    currentCorner = nextCorner;
  }
}
