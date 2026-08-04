import processing.sound.*;
AudioIn mic;
Amplitude amp;

int num = 40000;
float mts = PI/600;
float radiusScale = 1.0;
int rdtr = 120;
float rdu = 0.6;

PVector[] v = new PVector[num];
color[] c = new color[num];
float[] mtheta = new float[num];
float[] dtheta = new float[num];
float[] easing = new float[num];
int[] rdt = new int[num];

boolean mv = true;
boolean mo = true; 
boolean stagger = false; 

void setup() {
  colorMode(RGB, 255, 255, 255);
  fullScreen();

  for (int i = 0; i < num; i++) {
    c[i] = color(random(220,255), random(220,255), random(220,255), random(40,120));
    v[i] = new PVector(random(width), random(height));

    float thetaDeg = round(random(360));
    mtheta[i] = thetaDeg / 180.0 * PI;

    dtheta[i] = random(mts);
    rdt[i] = round(random(-rdtr, rdtr));
    easing[i] = random(0.02, 0.3);
  }

  frameRate(60);

  mic = new AudioIn(this, 0);
  mic.start();
  amp = new Amplitude(this);
  amp.input(mic);
}

void draw() {
  fill(0,0,0,6);
  rect(0, 0, width, height);

  noStroke();

  float level = constrain(amp.analyze(), 0, 0.1);
  float targetScale = map(level, 0, 0.1, 0.2, 3.0);
  radiusScale = lerp(radiusScale, targetScale, 0.1);

  float blueBoost = map(level, 0, 0.03, 0, 80);

  float cx = mv ? mouseX : width * 0.5;
  float cy = mv ? mouseY : height * 0.5;

  int start = 0;
  int step = 1;

  if (stagger) {
    start = frameCount % 2; // 0 or 1
    step = 2;
  }

  for (int i = start; i < num; i += step) {
    if (mo) mtheta[i] += dtheta[i];

    float orbit = rdt[i] * radiusScale;
    float tx = cx + cos(mtheta[i]) * orbit;
    float ty = cy + sin(mtheta[i]) * orbit;
    
    v[i].x = lerp(v[i].x, tx, easing[i]);
    v[i].y = lerp(v[i].y, ty, easing[i]);

    fill(red(c[i]), green(c[i]), min(255, blue(c[i]) + blueBoost), alpha(c[i]));
    ellipse(v[i].x, v[i].y, rdu, rdu);
  }
  fill(0);
  rect(0, 0, width, 15);
  fill(255);
}
