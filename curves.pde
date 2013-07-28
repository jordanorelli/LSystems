abstract class CurveDefinition {
  abstract String name();
  abstract Turtle drawAt(PApplet app, int x, int y, int generations);
}

class JSONCurveDefinition extends CurveDefinition {
  private String name;
  private String axiom;
  private LSystem sys;
  private PApplet app;
  private TurtleCommandSet cmds;
  private float scale;
  private float turn;
  private float heading;

  JSONCurveDefinition(PApplet app, String filename) {
    JSONObject json = loadJSONObject(filename);

    this.name    = json.getString("name");
    this.axiom   = json.getString("axiom");

    this.heading = radians(json.getFloat("heading"));
    this.scale   = json.getFloat("scale");
    this.turn    = radians(json.getFloat("turn"));
    if (json.hasKey("commands")) {
      this.cmds = new TurtleCommandSet(json.getJSONObject("commands"));
    }
    this.app = app;

    if (json.hasKey("ignore")) {
      this.sys = new LSystem(json.getString("ignore"));
    } else {
      this.sys = new LSystem();
    }

    String[] rules = json.getJSONArray("rules").getStringArray();
    for (String rule : rules) {
      if(!this.sys.parse(rule)) {
        println("unable to parse rule: " + rule);
      }
    }
  }

  String name() {
    return this.name;
  }

  Turtle drawAt(PApplet app, int x, int y, int generations) {
    Turtle t = new Turtle(this.app, this.cmds, this.scale, this.turn, this.heading);
    String program = this.sys.gen(this.axiom, generations);
    t.run(program, x, y);
    return t;
  }
}
