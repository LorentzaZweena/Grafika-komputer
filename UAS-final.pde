import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencvWajah;
OpenCV opencvMulut;
OpenCV opencvMata;

String currentExpression = "NEUTRAL";
String lockedExpression = "NEUTRAL";
int holdTimer = 0;

boolean faceDetected = false;

void setup() {
  size(800, 600, P3D);
  pixelDensity(1);
  surface.setTitle("Smile-O-Mat 3D - Multi-Expression Detector");
  
  video = new Capture(this, 320, 240);
  
  opencvWajah = new OpenCV(this, 320, 240);
  opencvWajah.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
  opencvMulut = new OpenCV(this, 320, 240);
  opencvMulut.loadCascade(OpenCV.CASCADE_MOUTH); 
  
  opencvMata = new OpenCV(this, 320, 240);
  opencvMata.loadCascade(OpenCV.CASCADE_EYE);
  
  video.start();
}

void draw() {
  if (video.available()) {
    video.read();
  }
  
  opencvWajah.loadImage(video);
  Rectangle[] faces = opencvWajah.detect();
  faceDetected = (faces.length > 0);
  
  String detectedNow = "NEUTRAL";
  
  if (faceDetected) {
    Rectangle f = faces[0];
    
    int mouthY = f.y + (int)(f.height * 0.58);
    int mouthH = (int)(f.height * 0.42);
    opencvMulut.loadImage(video);
    opencvMulut.setROI(f.x, mouthY, f.width, mouthH);
    Rectangle[] mouths = opencvMulut.detect();
    
    int eyeY = f.y + (int)(f.height * 0.15);
    int eyeH = (int)(f.height * 0.40);
    opencvMata.loadImage(video);
    opencvMata.setROI(f.x, eyeY, f.width, eyeH);
    Rectangle[] eyes = opencvMata.detect();
    
    if (mouths.length > 0) {
      Rectangle m = mouths[0];
      float mouthWidthRatio = (float)m.width / f.width;
      float mouthAspectRatio = (float)m.height / m.width;
      
      if (mouthAspectRatio > 0.68 && mouthWidthRatio > 0.35) {
        detectedNow = "SURPRISED";
      } else if (mouthWidthRatio > 0.41) {
        detectedNow = "SMILE";
      } else if (mouthWidthRatio < 0.31) {
        detectedNow = "SAD";
      }
    }
    
    if (detectedNow.equals("NEUTRAL") && eyes.length == 0) {
      detectedNow = "ANGRY";
    }
  }
  
  if (!faceDetected) {
    lockedExpression = "NONE";
    holdTimer = 0;
  } else {
    if (!detectedNow.equals("NEUTRAL")) {
      lockedExpression = detectedNow;
      holdTimer = 25; 
    } else {
      if (holdTimer > 0) {
        holdTimer--;
      } else {
        lockedExpression = "NEUTRAL";
      }
    }
  }
  
  color bgColor = color(215);
  color statusColor = color(80);
  String statusText = "STATUS: Mencari Wajah...";
  
  if (lockedExpression.equals("SMILE")) {
    bgColor = color(195, 255, 195);
    statusColor = color(0, 140, 0);
    statusText = "EKSPRESI: SMILE! (Senang) :D";
  } else if (lockedExpression.equals("SURPRISED")) {
    bgColor = color(255, 245, 175); 
    statusColor = color(180, 130, 0);
    statusText = "EKSPRESI: SURPRISED! (Kaget) :O";
  } else if (lockedExpression.equals("ANGRY")) {
    bgColor = color(255, 190, 190);
    statusColor = color(190, 0, 0);
    statusText = "EKSPRESI: ANGRY! (Marah) >:(";
  } else if (lockedExpression.equals("SAD")) {
    bgColor = color(190, 220, 255); // Biru sendu
    statusColor = color(0, 70, 180);
    statusText = "EKSPRESI: SAD (Sedih) :(";
  } else if (lockedExpression.equals("NEUTRAL")) {
    bgColor = color(215);
    statusColor = color(60);
    statusText = "EKSPRESI: NEUTRAL (Coba Senyum / Marah / Kaget!)";
  }
  
  background(bgColor);
  
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  image(video, 20, 20, 160, 120);
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
  for (int i = 0; i < faces.length; i++) {
    rect(20 + faces[i].x * 0.5, 20 + faces[i].y * 0.5, faces[i].width * 0.5, faces[i].height * 0.5);
  }
  
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("SMILE-O-MAT 3D", width / 2, 50);
  
  textSize(22);
  fill(statusColor);
  text(statusText, width / 2, height - 50);
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
  
  lights();
  translate(width / 2, height / 2, 0);
  noStroke();
  float unit = 100;
  
  pushMatrix();
  if (lockedExpression.equals("ANGRY")) {
    fill(255, 160, 60);
  } else {
    fill(255, 255, 0);
  }
  scale(3.0 * unit, 3.4 * unit, 1.5 * unit);
  sphere(0.5);
  popMatrix();
  
  float eyeScale = lockedExpression.equals("SURPRISED") ? 1.35 : (lockedExpression.equals("SAD") ? 0.85 : 1.0);
  float browY = -0.30;
  float browAngle = 0;
  
  if (lockedExpression.equals("SMILE")) {
    browY = -0.34;
    browAngle = -0.08;
  } else if (lockedExpression.equals("SURPRISED")) {
    browY = -0.37;
    browAngle = 0;
  } else if (lockedExpression.equals("ANGRY")) {
    browY = -0.25;
    browAngle = 0.35; 
  } else if (lockedExpression.equals("SAD")) {
    browY = -0.31;
    browAngle = -0.28; 
  }
  
  pushMatrix();
  translate(-0.22 * 3 * unit, -0.13 * 3.4 * unit, 0.70 * 1.5 * unit);
  fill(0);
  scale(0.15 * 3 * unit * eyeScale, 0.19 * 3.4 * unit * eyeScale, 0.08 * 1.5 * unit);
  sphere(0.5);
  popMatrix();
  
  pushMatrix();
  translate(0.22 * 3 * unit, -0.13 * 3.4 * unit, 0.70 * 1.5 * unit);
  fill(0);
  scale(0.15 * 3 * unit * eyeScale, 0.19 * 3.4 * unit * eyeScale, 0.08 * 1.5 * unit);
  sphere(0.5);
  popMatrix();
  
  pushMatrix();
  translate(-0.22 * 3 * unit, browY * 3.4 * unit, 0.70 * 1.5 * unit);
  rotateZ(browAngle);
  fill(0);
  box(0.30 * 3 * unit, 0.045 * 3.4 * unit, 0.04 * 1.5 * unit);
  popMatrix();
  
  pushMatrix();
  translate(0.22 * 3 * unit, browY * 3.4 * unit, 0.70 * 1.5 * unit);
  rotateZ(-browAngle);
  fill(0);
  box(0.30 * 3 * unit, 0.045 * 3.4 * unit, 0.04 * 1.5 * unit);
  popMatrix();
  
  pushMatrix();
  translate(0, 0.02 * 3.4 * unit, 0.70 * 1.5 * unit);
  fill(255, 165, 0);
  scale(0.12 * 3 * unit, 0.10 * 3.4 * unit, 0.08 * 1.5 * unit);
  sphere(0.5);
  popMatrix();
  
  float mouthW = 0.25;
  float mouthH = 0.06;
  if (lockedExpression.equals("SMILE")) {
    mouthW = 0.48;
    mouthH = 0.14;
  } else if (lockedExpression.equals("SURPRISED")) {
    mouthW = 0.26;
    mouthH = 0.26; 
  } else if (lockedExpression.equals("ANGRY")) {
    mouthW = 0.28;
    mouthH = 0.04; 
  } else if (lockedExpression.equals("SAD")) {
    mouthW = 0.20;
    mouthH = 0.07; 
  }
  
  pushMatrix();
  translate(0, 0.22 * 3.4 * unit, 0.70 * 1.5 * unit);
  fill(255, 0, 0);
  scale(mouthW * 3 * unit, mouthH * 3.4 * unit, 0.06 * 1.5 * unit);
  sphere(0.5);
  popMatrix();
}
