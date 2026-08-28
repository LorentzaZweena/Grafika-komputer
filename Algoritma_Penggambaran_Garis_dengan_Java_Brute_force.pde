int x1 = 50, y1 = 50; 
int x2 = 200, y2 = 150; 
 
void setup() { 
  size(300, 200); 
  background(255); 
  stroke(0); 
   
  drawBruteForceLine(x1, y1, x2, y2); 
} 
 
void drawBruteForceLine(int x1, int y1, int x2, int y2) { 
  float dx = x2 - x1; 
  float dy = y2 - y1; 
 
  // Avoid division by zero 
  if (abs(dx) >= abs(dy)) { 
    // Line is more horizontal 
    float m = dy / dx; 
    for (int x = x1; x <= x2; x++) { 
      float y = y1 + m * (x - x1); 
      point(x, round(y)); 
    } 
  } else { 
    // Line is more vertical 
    float m_inv = dx / dy; 
    for (int y = y1; y <= y2; y++) { 
      float x = x1 + m_inv * (y - y1); 
      point(round(x), y); 
    } 
  } 
}
