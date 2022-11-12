Properties p;
ParticleSystem ps;

float v_me = 0;  //Mercury's velocity
float v_v = 0;  //Venice's velocity
float v_e = 0;  //Earth's velocity
float v_ma = 0;  //Mars's velocity
float v_j = 0;  //Jupiter's velocity
float v_s = 0;  //Saturn's velocity
float v_u = 0;  //Uranus's velocity
float v_n = 0;  //Neptune's velocity
float v_mo = 0;  //Moon's velocity
float v_c1 = 0;  //comet's velocity
float v_c2 = 0;  //comet's velocity

void setup(){
  size(1600, 1000, P3D);
  noStroke();
  textFont(createFont("ArialMT", 18), 18);
  p = new Properties();
  ps = new ParticleSystem(new PVector(0, 0));
}

void planet(float s, float R, float r, float a, float b){
   pushMatrix();
    noStroke();
    rotateY(a);
    translate(R, 0, 0);
    rotateY(b);
    translate(r, 0, 0);
    sphere(s);
  popMatrix();
}

void planet_ring(float R, float r, float a, float b, float x){
  pushMatrix();
    noStroke();
    rotateY(a);
    translate(R, 0, 0);
    rotateY(b);
    translate(r, 0, 0);
    rotateX(x);
    stroke(250, 250, 210);
    noFill();
    for(float i=0;i<=1;i+=0.01)
      ellipse(0, 0, 35*(2.5+i), 35*(2.5+i));
  popMatrix();
}

void comet(float s, float x, float z, float a, float angle){
  pushMatrix();
    noStroke();
    rotateX(angle);
    translate(x-200, 0, z-200);
    rotateY(a);
    translate(x, 0, z);
    sphere(s);
    rotateX(-PI/2);
    ps.addParticle();
    ps.run();
  popMatrix();
}

void orbit(float R){
  pushMatrix();
    rotateX(PI/2);
    stroke(107,255,252);
    noFill();
    ellipse(0, 0, R*2, R*2);
  popMatrix();
}

void orbit_sub(float R, float r, float a){
  pushMatrix();
    stroke(107,255,252);
    rotateY(a);
    translate(R, 0, 0);
    noFill();
    rotateX(PI/2);
    ellipse(0, 0, r*2, r*2);
  popMatrix();
}

void draw(){
  float R; //Planet's orbital radius
  background(0);
  translate(width/2, height/2, -50);
  lightSpecular(100, 100, 100);
  pointLight(255, 209, 97, 0, 0, 0);
  ambientLight(200, 200, 200);
  specular(255, 255, 255);
  emissive(10, 10, 10);
  shininess(10);
  rotateX(-PI/6);
  v_me = v_me + 0.1 * p.getVelocity();
  v_v = v_v + 0.03 * p.getVelocity();
  v_e = v_e + 0.02 * p.getVelocity();
  v_mo = v_mo + 0.05 * p.getVelocity();
  v_ma = v_ma + 0.01 * p.getVelocity();
  v_j = v_j + 0.003 * p.getVelocity();
  v_s = v_s + 0.001 * p.getVelocity();
  v_u = v_u + 0.0005 * p.getVelocity();
  v_n = v_n + 0.0003 * p.getVelocity();
  v_c1 = v_c1 + 0.01 * p.getVelocity();
  v_c2 = v_c2 + 0.000001 * p.getVelocity();
  R = width/25;
  
  fill(255, 144, 0);
  planet(100, 0, 0, 0, 0);  //Sun

  fill(230, 230, 230);
  planet(8, R*2, 0, v_me, 0);  //Mercury
  orbit(R*2);
  
  fill(218, 165, 32);
  planet(19, R*3, 0, v_v, 0);  //Venice
  orbit(R*3);

  fill(34, 139, 34);
  planet(20, R*4, 0, v_e, 0);  //Earth
  orbit(R*4);
  
  fill(211, 211, 211);
  planet(5, R*4, 50, v_e, v_mo);  //Moon
  orbit_sub(R*4, 50, v_e);
  
  fill(205, 92, 92);
  planet(10, R*5, 0, v_ma, 0);  //Mars
  orbit(R*5);
  
  fill(244, 164, 96);
  planet(40, R*7, 0, v_j, 0);  //Jupiter
  orbit(R*7);
  
  fill(230, 230, 250);
  planet(25, R*10, 0, v_u, 0);  //Uranus
  orbit(R*10);
  
  fill(65, 105, 225);
  planet(23, R*11, 0, v_n, 0);  //Neptune
  orbit(R*11);
  
  fill(250, 250, 210);
  planet(35, R*8, 0, v_s, 0);  //Saturn
  planet_ring(R*8, 0, v_s, 0, PI/2);
  orbit(R*8);
  
  fill(126, 194, 196);
  comet(5, 1000, 200, v_c1, PI/3);  //comet1
  
  fill(250, 153, 160);
  comet(5, 800, 800, v_c2, -PI/7);  //comet2
  
  p.update();
}

void mouseReleased(){
  p.release();
}

class Properties{
  HandleA velocity = new HandleA(500, -400, "Velocity", 1);
  
  Properties(){};
  
  void update(){
    velocity.update();
  }
  
  void release(){
    velocity.release();
  }
  
  int getVelocity(){ return velocity.getA(); }
}


class HandleA extends Handle{
  final int handleAHeight = 50;
  int x, y;
  int offsetY = 30;
  private int A;
  Handle handleA;
  String title;
  
  HandleA(){};
  
  HandleA(int ix, int iy, String s, int a){
    x = ix; y = iy;
    handleA = new Handle(x, y + offsetY + 10, "r", color(255, 0, 0), A = a);
    title = s;
  }
  
  int getA(){ return handleA.getColor(); }
  
  void release(){
    handleA.release();
  }
  
  void update(){
    A = getA();
    handleA.update();
    noStroke(); fill(255);
    rect(x, y, handleWidth, offsetY - 8);
    fill(0);
    text(title + ": (×" + A + ")", x + 4, y + offsetY - 12);
    stroke(0); noFill();
    rect(x, y, handleWidth, handleAHeight);
  }
}

public class Handle{
  int handleX, handleY;
  final int handleWidth = 260;
  final int boxWidth = 20, boxHeight = 20;
  int boxXleft, boxXright, boxYtop, boxYbottom;
  int value;
  color c;
  String label;
  boolean over;
  boolean press;
  boolean locked = false;
  
  Handle(){};
  
  Handle(int x, int y, String s, color cl, int v){
    handleX = x; handleY = y;
    setBoxPosition();
    label = s;
    c = cl;
    value = v;
  }
  
  void setBoxPosition(){
    boxXleft = handleX + value - boxWidth / 2;  boxYbottom = handleY - boxHeight / 2;
    boxXright = handleX + value + boxWidth / 2; boxYtop = handleY + boxHeight / 2;
  }
  
  int getColor(){ return value; }
  
  int getValue(){
    int val = mouseX - width / 2  - handleX + 35;
    if(val < 0) return 0;
    else if(val > 255) return 255;
    else return val;
  } 
  
  void update(){
    setBoxPosition();

    over();
    boxPress();
    
    if(press) {
      value = getValue();
    }
    
    display();
  }
  
  void over(){
    if(overRect(boxXleft, boxYbottom, boxXright, boxYtop)) over = true;
    else over = false;
  }
  
  void boxPress(){
    if(over && mousePressed || locked) {
      press = true;
      locked = true;
    }
    else{
      press = false;
    }
  }
  
  void release(){
    locked = false;
  }
  
  boolean overRect(int xl, int yb, int xr, int yt){
    if (mouseX >= (xl+width/2-30) && mouseX <= (xr+width/2-30) && mouseY >= (yb+height/2+20) && mouseY <= (yt+height/2+20)) return true;
    else return false;
  }
  
  void display(){
    stroke(c);
    rotateX(PI/6);
    line(handleX, handleY, handleX + value, handleY);
    fill(c);
    rect(boxXleft, boxYbottom, boxWidth, boxWidth);
    stroke(0);
    if(over || press) {
      line(boxXleft, boxYbottom, boxXright, boxYtop);
      line(boxXleft, boxYtop, boxXright, boxYbottom);
    }
  }
}


class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-0.2, 0.2), random(-5, 0));
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display_patricle();
  }

  // Method to update position
  void update() {
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display_patricle() {
    stroke(51,131,255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 2, 2);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
