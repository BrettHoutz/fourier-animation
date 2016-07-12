import java.util.*; //<>//

int n = 30;
int f = 200;
float l = 90;
int w, h;
Spinner[] spinners;
LinkedList<Trail> trails;

void setup() {
  w = 500;
  h = 300;
  size(500, 280);
  frameRate(30);
  float speed = TWO_PI / (f);
  trails =  new LinkedList<Trail>();
  
  // create list of spinners
  spinners = new Spinner[n];
  spinners[0] = new Spinner(w/2, h/2, l, l, speed, speed, 0);
  for (int i=1; i<n; i++) spinners[i] = spinners[i-1].spawnChild();
}

void draw() {
  background(255);
  
  // update and draw trails
  addTrail(spinners[n-1].endX, spinners[n-1].endY);
  for (Trail trail : trails) {
    if (trail.finished) trail.draw();
  }
  
  // draw spinners
  strokeWeight(5);
  for (int i=0; i<n; i++) {
    float b = spinners[i].bright;
    if (b < 1) {
      stroke(0, 0, 255*b);
    } else {
      stroke(0, 255*(b-1), 255);
    }
    line(spinners[i].originX, spinners[i].originY, spinners[i].endX, spinners[i].endY);
  }
  
  // update spinner positions
  for (int i=0; i<n; i++) spinners[i].update();
  
  // save frames the second time around
  //  if(frameCount >= 2*f) exit();
  //  if(frameCount >= f && frameCount % 4 == 0) saveFrame("../robo/fourier/##.png");
}

void addTrail(float x, float y) {
  // finish most recently started trail
  if (trails.size() > 0) trails.peekFirst().finish(x, y);
  // start new trail
  trails.addFirst(new Trail(x, y));
  // remove oldest trail
  if (trails.size() >= 100) trails.removeLast();
}