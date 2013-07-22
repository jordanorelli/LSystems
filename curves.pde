
abstract class CurveDefinition {
  abstract String name();
  abstract Turtle drawAt(PApplet app, int x, int y, int generations);
}

CurveDefinition hilbertCurve = new CurveDefinition() {

  String name() {
    return "hilbertCurve";
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.rule('A', "-BF+AFA+FB-");
    s.rule('B', "+AF-BFB-FA+");
    String program = s.gen("A", generations);

    Turtle t = new Turtle(app, x, y, PI * 0.5, 8.0, PI / 2.0);
    t.cmd('A', drawForward);
    t.cmd('B', drawForward);
    t.run(program);
    return t;
  }
};

CurveDefinition gosperCurve = new CurveDefinition() {

  String name() {
    return "gosperCurve";
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.rule('l', "l+r++r-l--ll-r+");
    s.rule('r', "-l+rr++r+l--l-r");
    String program = s.gen("l", generations);

    Turtle t = new Turtle(app, x, y, PI * 0.5, 4.0, PI / 3.0);
    t.run(program);
    return t;
  }
};

CurveDefinition tree_1_24_a = new CurveDefinition() {

  String name() {
    return "tree_1_24_a";
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.rule('F', "F[+F]F[-F]F");
    String program = s.gen("F", generations);

    Turtle t = new Turtle(app, x, y, radians(90), 4.0, radians(25.7));
    t.run(program);
    return t;
  }
};

CurveDefinition tree_1_24_b = new CurveDefinition() {

  String name() {
    return "tree_1_24_b";
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.rule('F', "F[+F]F[-F][F]");
    String program = s.gen("F", generations);

    Turtle t = new Turtle(app, x, y, radians(90), 8.0, radians(20));
    t.run(program);
    return t;
  }
};

CurveDefinition tree_1_27 = new CurveDefinition() {

  String name() { 
    return "tree_1_27";
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    SProduction p = new SProduction('F');
    p.add("F[+F]F[-F]F", 1.0 / 3.0);
    p.add("F[+F]F", 1.0 / 3.0);
    p.add("F[-F]F", 1.0 / 3.0);
    s.rule(p);
    String program = s.gen("F", generations);

    Turtle t = new Turtle(app, x, y, radians(90), 8.0, radians(20));
    t.run(program);
    return t;
  }
};

CurveDefinition jorelli_0 = new CurveDefinition() {
  String name() {
    return "jorelli_0";
  }
  
  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();

    SProduction p = new SProduction('F');
    p.add("FF", 0.5);
    p.add("F[+A]F", 0.25);
    p.add("F[-B]F", 0.25);
    s.rule(p);

    p = new SProduction('A');
    p.add("F-F", 0.25);
    p.add("F-FF", 0.25);
    p.add("F-F-F", 0.25);
    p.add("F-F+F", 0.25);
    s.rule(p);

    s.rule('B', "F+F");

    String program = s.gen("F", generations);

    Turtle t = new Turtle(app, x, y, radians(90), 8.0, radians(20));
    t.cmd('A', drawForward);
    t.cmd('B', drawForward);
    t.run(program);
    return t;    
  }
};

CurveDefinition left_context_0 = new CurveDefinition() {
  String name() {
    return "left_context_0";
  }
  
  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.ruleLeft('b', 'a', "b");
    s.rule('b', "a");
    String program = s.gen("baaaaaaa", generations);

    Turtle t = new Turtle(app, x, y, 0, 8.0, radians(90));
    t.cmd('a', drawForward);
    t.cmd('b', drawForwardRed);
    t.run(program);
    return t;    
  }
};

CurveDefinition left_context_1 = new CurveDefinition() {
  String name() {
    return "left_context_1";
  }
  
  Turtle drawAt(PApplet app, int x, int y, int generations) {
    LSystem s = new LSystem();
    s.ruleLeft('b', 'a', "b");
    s.rule('b', "a");
    String program = s.gen("aabaa[+aa+aaa][-FF[+FF]]aaaaaaa", generations);

    Turtle t = new Turtle(app, x, y, radians(90), 8.0, radians(20));
    t.cmd('a', drawForward);
    t.cmd('b', drawForwardRed);
    t.run(program);
    return t;    
  }
};

