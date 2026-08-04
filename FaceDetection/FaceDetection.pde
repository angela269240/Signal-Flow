import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture cam;
OpenCV opencv;

void setup() {
  size(640, 480);

  cam = new Capture(this, 640, 480);
  cam.start();

  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
}

void draw() {
  background(0);

  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0);

  opencv.loadImage(cam);

  Rectangle[] faces = opencv.detect();

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);

  int validFaces = 0;

  for (int i = 0; i < faces.length; i++) {
    Rectangle f = faces[i];

    float ratio = f.width / (float) f.height;

    boolean sizeOK = f.width > 60 && f.height > 60 && f.width < 300 && f.height < 300;
    boolean shapeOK = ratio > 0.75 && ratio < 1.35;
    boolean positionOK = f.y > 20;

    if (sizeOK && shapeOK && positionOK) {
      rect(f.x, f.y, f.width, f.height);
      validFaces++;
    }
  }

  fill(255);
  noStroke();
  rect(0, 0, 160, 30);
  fill(0);
  textSize(16);
  text("Faces: " + validFaces, 10, 20);
}
