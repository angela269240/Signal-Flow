import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

AudioIn mic;
Amplitude amp;

Capture cam;
OpenCV opencv;

int num = 40000;
float mts = PI/1200;
float radiusScale = 0.5;
int rdtr = 120;
float rdu = 0.6;

PVector[] v = new PVector[num];
color[] c = new color[num];
float[] mtheta = new float[num];
float[] dtheta = new float[num];
float[] easing = new float[num];
int[] rdt = new int[num];

boolean mo = true;
boolean stagger = false;

boolean faceDetected = false;
float blobX, blobY;
float targetX, targetY;

void setup() {
  fullScreen();
  colorMode(RGB, 255, 255, 255);
  frameRate(60);

  for (int i = 0; i < num; i++) {
    c[i] = color(random(220,255), random(220,255), random(220,255), random(40,120));
    v[i] = new PVector(random(width), random(height));

    float thetaDeg = round(random(360));
    mtheta[i] = thetaDeg / 180.0 * PI;

    dtheta[i] = random(mts);
    rdt[i] = round(random(-rdtr, rdtr));
    easing[i] = random(0.02, 0.3);
  }

  mic = new AudioIn(this, 0);
  mic.start();
  amp = new Amplitude(this);
  amp.input(mic);


  cam = new Capture(this, 640, 480);
  cam.start();

  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  blobX = width * 0.5;
  blobY = height * 0.5;
  targetX = blobX;
  targetY = blobY;

  background(0);
}

void draw() {
  fill(0, 0, 0, 6);
  rect(0, 0, width, height);

  faceTracking();

  blobX = lerp(blobX, targetX, 0.12);
  blobY = lerp(blobY, targetY, 0.12);

  if (faceDetected) {
    float level = constrain(amp.analyze(), 0, 0.1);
    float targetScale = map(level, 0, 0.1, 0.2, 3.0);
    radiusScale = lerp(radiusScale, targetScale, 0.1);
    int start = 0;
    int step = 1;
    if (stagger) {
      start = frameCount % 2;
      step = 2;
    }
    noStroke();

    for (int i = start; i < num; i += step) {
      if (mo) mtheta[i] += dtheta[i];
      float orbit = rdt[i] * radiusScale;
      float tx = blobX + cos(mtheta[i]) * orbit;
      float ty = blobY + sin(mtheta[i]) * orbit;
      
      v[i].x = lerp(v[i].x, tx, easing[i]);
      v[i].y = lerp(v[i].y, ty, easing[i]);
      
      fill(red(c[i]), green(c[i]), blue(c[i]), alpha(c[i]));
      ellipse(v[i].x, v[i].y, rdu, rdu);
    }

  }
}

void faceTracking() {
  if (cam.available()) {
    cam.read();
  }

  opencv.loadImage(cam);
  Rectangle[] faces = opencv.detect();

  Rectangle bestFace = null;
  int biggestArea = 0;

  for (int i = 0; i < faces.length; i++) {
    Rectangle f = faces[i];
    float ratio = f.width / (float)f.height;

    boolean sizeOK = f.width > 60 && f.height > 60 && f.width < 300 && f.height < 300;
    boolean shapeOK = ratio > 0.75 && ratio < 1.35;
    boolean positionOK = f.y > 20;

    if (sizeOK && shapeOK && positionOK) {
      int area = f.width * f.height;
      if (area > biggestArea) {
        biggestArea = area;
        bestFace = f;
      }
    }
  }

  if (bestFace != null) {
    float faceCenterX = bestFace.x + bestFace.width * 0.5;
    float faceCenterY = bestFace.y + bestFace.height * 0.5;

    targetX = map(cam.width - faceCenterX, 0, cam.width, 0, width);
    targetY = map(faceCenterY, 0, cam.height, 0, height);
    
    blobX = lerp(blobX, targetX, 0.15);
    blobY = lerp(blobY, targetY, 0.15);
    faceDetected = true;
  } else{
    faceDetected = false;
  }
}
