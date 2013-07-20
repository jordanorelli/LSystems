ArrayList<Turtle> turtles;
boolean FULL_SCREEN = false;
int WIDTH = 720;
int HEIGHT = 850;

void setup() {
  smooth();  
  background(255);
  stroke(0);
  strokeWeight(2);
  strokeCap(ROUND);
  
  turtles = new ArrayList<Turtle>();
}

void draw() {
  background(255);
}

void mousePressed(MouseEvent event) {
  pushTurtle(tree_1_27(event.getX(), event.getY()));
}

void mouseWheel(MouseEvent event) {
  println(event.getAmount());
}

void keyPressed(KeyEvent event) {
  switch (event.getKeyCode()) {
  case 8:
    popTurtle();
  }
}

void pushTurtle(Turtle t) {
  turtles.add(t);
}

void popTurtle() {
  int n = turtles.size() - 1;
  Turtle t = turtles.get(n);
  t.unregister(this);
  turtles.remove(n);
}

boolean sketchFullScreen() {
  return FULL_SCREEN;
}

int sketchWidth() {
  return FULL_SCREEN ? 1440 : WIDTH;
}

int sketchHeight() {
  return FULL_SCREEN ? 900 : HEIGHT;
}

String sketchRenderer() {
  return P2D;
}

Turtle hilbertCurve() {
  LSystem s = new LSystem();
  s.rule('A', "-BF+AFA+FB-");
  s.rule('B', "+AF-BFB-FA+");
  String program = s.gen("A", 7);

  Turtle t = new Turtle(this, 0, height, PI * 0.5, 4.0, PI / 2.0);
  t.run(program);
  return t;
}

Turtle gosperCurve() {
  LSystem s = new LSystem();
  s.rule('l', "l+r++r-l--ll-r+");
  s.rule('r', "-l+rr++r+l--l-r");
  String program = s.gen("l", 5);

  Turtle t = new Turtle(this, width * 0.75, height * 0.25, PI * 0.5, 4.0, PI / 3.0);
  t.run(program);
  return t;
}

Turtle tree_1_24_a() {
  LSystem s = new LSystem();
  s.rule('F', "F[+F]F[-F]F");
  String program = s.gen("F", 5);
  
  Turtle t = new Turtle(this, width * 0.5, height, radians(90), 4.0, radians(25.7));
  t.run(program);
  return t;
}

Turtle tree_1_24_b() {
  LSystem s = new LSystem();
  s.rule('F', "F[+F]F[-F][F]");
  String program = s.gen("F", 5);
  
  Turtle t = new Turtle(this, width * 0.5, height, radians(90), 8.0, radians(20));
  t.run(program);
  return t;
}

Turtle tree_1_27(float x, float y) {
  LSystem s = new LSystem();
  s.rule('F', "F[+F]F[-F]F", 1.0 / 3.0);
  s.rule('F', "F[+F]F", 1.0 / 3.0);
  s.rule('F', "F[-f]F", 1.0 / 3.0);
  String program = s.gen("F", 5);

  Turtle t = new Turtle(this, x, y, radians(90), 8.0, radians(20));
  t.run(program);
  return t;  
}

