Turtle t;

void setup() {
  size(800, 800, P2D);
  frameRate(60000);
  smooth();  
  background(255);
  stroke(0);
  strokeWeight(1);

  HashMap productions = new HashMap();
  productions.put('l', "l+r++r-l--ll-r+");
  productions.put('r', "-l+rr++r+l--l-r");
  String axiom = "l";

  for (int i = 0;  i < 5; i++) {
    axiom = gen(axiom, productions);
  }
  
  HashMap commands = new HashMap();
  commands.put('F', drawForward);
  commands.put('f', moveForward);
  commands.put('-', turnRight);
  commands.put('+', turnLeft);
  commands.put('r', drawForward);
  commands.put('l', drawForward);
  
  t = new Turtle(width * 0.75, height * 0.25, PI * 0.5, 4.0, PI / 3.0);
  t.run(commands, axiom);
}

void draw() {
  t.update();
}

String gen(String input, HashMap productions) {
  StringBuffer buf = new StringBuffer();
  for (int i = 0; i < input.length(); i++) {
    char c = input.charAt(i);
    if (!productions.containsKey(c)) {
      buf.append(c);
      continue;
    }
    buf.append((String)productions.get(c));
  }
  return buf.toString();
}
