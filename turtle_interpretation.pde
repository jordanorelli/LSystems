ArrayList<Turtle> turtles = new ArrayList<Turtle>();;
boolean FULL_SCREEN = false;
int WIDTH = 720;
int HEIGHT = 850;
CurveDefinition def;
int generations = 1;
ArrayList<CurveDefinition> curves = new ArrayList<CurveDefinition>();

void setup() {
  smooth();  
  background(255);
  stroke(0);
  strokeWeight(2);
  strokeCap(ROUND);
  setupParseRules();
  setupTurtleCommands();

  curves.add(tree_1_27);
  curves.add(jorelli_0);
  curves.add(jorelli_1);  
  curves.add(left_context_0);
  curves.add(left_context_1);  
  curves.add(tree_1_24_b);
  curves.add(tree_1_24_a);
  curves.add(gosperCurve);
  curves.add(hilbertCurve);
  curves.add(new JSONCurveDefinition(this, "trees/hilbert.json"));
  def = curves.get(0);
}

void draw() {
  background(255);
  fill(0);
  text(generations + " " + def.name(), mouseX, mouseY);
}

void mousePressed(MouseEvent event) {
  pushTurtle(def.drawAt(this, event.getX(), event.getY(), generations));
}

void mouseWheel(MouseEvent event) {
  println(event.getAmount());
  if (event.getAmount() > 0) {
    generations++;
  } else {
    if (generations > 1) {
      generations--;
    }
  }
}

void keyPressed(KeyEvent event) {
  switch (event.getKeyCode()) {
  case 8:
    popTurtle();
    break;
  case 39:
    nextCurve(false);
    break;
  case 37:
    nextCurve(true);
    break;
  default:
    println(event.getKeyCode());
  }
}

void nextCurve(boolean reverse) {
  int i = curves.indexOf(def);
  if (reverse) {
    i--;
  } 
  else { 
    i++;
  }

  if (i < 0) {
    i = curves.size() - 1;
  }
  if (i >= curves.size()) {
    i = 0;
  }
  def = curves.get(i);  
}

void pushTurtle(Turtle t) {
  turtles.add(t);
}

void popTurtle() {
  int n = turtles.size() - 1;
  if (n < 0) {
    return;
  }
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

