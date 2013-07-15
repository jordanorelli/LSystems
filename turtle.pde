boolean REPORT_MOVES = true;

class Turtle {
  PVector position;
  float heading;
  float stride;
  float theta;
  HashMap commands;
  String program;
  
  Turtle(float x, float y, float heading, float stride, float theta) {
    this.position = new PVector(x, y);
    this.heading = heading;
    this.stride = stride;
    this.theta = theta;
  }
  
  void run(HashMap commands, String program) {
    this.commands = commands;
    this.program = program;
  }
  
  void update() {
    if (frameCount >= this.program.length()) {
      return;
    }
    char c = this.program.charAt(frameCount);
    if (!this.commands.containsKey(c)) {
      return;
    }
    TurtleCommand cmd = (TurtleCommand)this.commands.get(c);
    cmd.run(this);    
  }
}

abstract class TurtleCommand {
  public abstract void run(Turtle t);
}

TurtleCommand drawForward = new TurtleCommand() {
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("draw forward");
    }
    float x = t.position.x + t.stride * cos(t.heading);
    float y = t.position.y - t.stride * sin(t.heading);
    line(t.position.x, t.position.y, x, y);
    t.position.x = x;
    t.position.y = y; 
  }
};

TurtleCommand moveForward = new TurtleCommand() {
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("move forward");
    }
    t.position.x += t.stride * cos(t.heading);
    t.position.y -= t.stride * sin(t.heading);
  }
};

TurtleCommand turnLeft = new TurtleCommand() {
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("turn left");
    }
    t.heading += t.theta;
  }
};

TurtleCommand turnRight = new TurtleCommand() {
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("turn right");
    }
    t.heading -= t.theta;
  }
};
