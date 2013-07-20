ArrayList<Turtle> turtles;

void setup() {
  size(1440, 900, P2D);
  frameRate(60000);
  smooth();  
  background(255);
  stroke(0);
  strokeWeight(2);
  strokeCap(ROUND);
  
  turtles = new ArrayList<Turtle>();
  turtles.add(tree_1_6_a());
}

void draw() {
  for (Turtle t : turtles) {
    t.update();
  }
}

Turtle hilbertCurve() {
  LSystem s = new LSystem();
  s.rule('A', "-BF+AFA+FB-");
  s.rule('B', "+AF-BFB-FA+");
  String program = s.gen("A", 7);

  Turtle t = new Turtle(0, height, PI * 0.5, 4.0, PI / 2.0);
  t.run(program);
  return t;
}

Turtle gosperCurve() {
  LSystem s = new LSystem();
  s.rule('l', "l+r++r-l--ll-r+");
  s.rule('r', "-l+rr++r+l--l-r");
  String program = s.gen("l", 5);

  Turtle t = new Turtle(width * 0.75, height * 0.25, PI * 0.5, 4.0, PI / 3.0);
  t.run(program);
  return t;
}

Turtle tree_1_6_a() {
  LSystem s = new LSystem();
  s.rule('F', "F[+F]F[-F]F");
  String program = s.gen("F", 5);
  
  Turtle t = new Turtle(width * 0.5, height, radians(90), 4.0, radians(25.7));
  t.run(program);
  return t;
}

Turtle tree_1_6_b() {
  LSystem s = new LSystem();
  s.rule('F', "F[+F]F[-F][F]");
  String program = s.gen("F", 5);
  
  Turtle t = new Turtle(width * 0.5, height, radians(90), 8.0, radians(20));
  t.run(program);
  return t;
}
