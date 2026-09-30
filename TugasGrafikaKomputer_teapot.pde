void setup() {
  size(800, 600, P3D);
}

void draw() {
  background(0);
  lights();

  translate(width / 2, height / 2 + 30, 0);
  rotateY(frameCount * 0.008 + map(mouseX, 0, width, -PI, PI));
  rotateX(map(mouseY, 0, height, -PI, PI));

  stroke(255, 0, 0);
  strokeWeight(1.2);
  noFill();

  drawTeapot(1.2);
}

void drawTeapot(float scaleVal) {
  pushMatrix();
  scale(scaleVal);

  int detailLathe = 32; 
  PVector[] profile = {
    new PVector(0, 90),     
    new PVector(50, 90),   
    new PVector(70, 80),    
    new PVector(100, 40),   
    new PVector(105, 0),    
    new PVector(90, -40),   
    new PVector(65, -60),   
    new PVector(67, -65),   
    new PVector(55, -65),   
    new PVector(40, -75),   
    new PVector(20, -90),   
    new PVector(25, -100),  
    new PVector(0, -105)    
  };

  for (int i = 0; i < profile.length - 1; i++) {
    beginShape(QUAD_STRIP);
    for (int j = 0; j <= detailLathe; j++) {
      float angle = TWO_PI * j / detailLathe;
      float cosA = cos(angle);
      float sinA = sin(angle);

      float x1 = profile[i].x * cosA;
      float z1 = profile[i].x * sinA;
      float y1 = profile[i].y;

      float x2 = profile[i + 1].x * cosA;
      float z2 = profile[i + 1].x * sinA;
      float y2 = profile[i + 1].y;

      vertex(x1, y1, z1);
      vertex(x2, y2, z2);
    }
    endShape();
  }

  drawTubeCurve(
    new PVector(-60, -50, 0),   
    new PVector(-140, -40, 0),  
    new PVector(-140, 60, 0),  
    new PVector(-55, 70, 0),    
    10, 10, 16                 
  );

  drawTubeCurve(
    new PVector(55, 45, 0),     
    new PVector(105, 30, 0),    
    new PVector(135, -20, 0),   
    new PVector(145, -50, 0),   
    16, 8, 16                   
  );

  popMatrix();
}

void drawTubeCurve(PVector p0, PVector p1, PVector p2, PVector p3, float rStart, float rEnd, int steps) {
  int ringSegs = 12;

  for (int i = 0; i < steps; i++) {
    float t1 = (float) i / steps;
    float t2 = (float) (i + 1) / steps;

    PVector pos1 = getBezierPoint(p0, p1, p2, p3, t1);
    PVector pos2 = getBezierPoint(p0, p1, p2, p3, t2);

    float rad1 = lerp(rStart, rEnd, t1);
    float rad2 = lerp(rStart, rEnd, t2);

    PVector dir = PVector.sub(pos2, pos1).normalize();
    PVector normal = new PVector(-dir.y, dir.x, 0).normalize();
    PVector binormal = dir.cross(normal).normalize();

    beginShape(QUAD_STRIP);
    for (int j = 0; j <= ringSegs; j++) {
      float a = TWO_PI * j / ringSegs;
      float ca = cos(a);
      float sa = sin(a);

      PVector v1 = PVector.add(pos1, PVector.mult(normal, ca * rad1)).add(PVector.mult(binormal, sa * rad1));
      PVector v2 = PVector.add(pos2, PVector.mult(normal, ca * rad2)).add(PVector.mult(binormal, sa * rad2));

      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}

PVector getBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float u = 1 - t;
  float tt = t * t;
  float uu = u * u;
  float uuu = uu * u;
  float ttt = tt * t;

  PVector p = PVector.mult(p0, uuu);
  p.add(PVector.mult(p1, 3 * uu * t));
  p.add(PVector.mult(p2, 3 * u * tt));
  p.add(PVector.mult(p3, ttt));
  return p;
}
