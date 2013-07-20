import java.util.Stack;

boolean REPORT_MOVES = true;

class TurtleState {
  public PVector position;
  public float heading;
  
  TurtleState(PVector position, float heading) {
    this.position = position;
    this.heading = heading;
  }
}

class Turtle {
  public PVector position;
  public float heading;
  public float stride;
  public float theta;
  private HashMap commands;
  private String program;
  private Stack history;
  
  Turtle(float x, float y, float heading, float stride, float theta) {
    this.position = new PVector(x, y);
    this.heading = heading;
    this.stride = stride;
    this.theta = theta;
    this.commands = new HashMap();
    this.setDefaultCommands();
    this.history = new Stack();
  }
  
  public void setDefaultCommands() {
    this.cmd('F', drawForward);
    this.cmd('f', moveForward);
    this.cmd('-', turnRight);
    this.cmd('+', turnLeft);
    this.cmd('r', drawForward);
    this.cmd('l', drawForward);
    this.cmd('[', fork);
    this.cmd(']', unfork);
  } 
  
  public void run(String program) {
    println(program);
    this.program = program;
  }
  
  public void cmd(char c, TurtleCommand command) {
    this.commands.put(c, command);
  }
  
  void update() {
    if (frameCount-1 >= this.program.length()) {
      return;
    }
    char c = this.program.charAt(frameCount-1);
    if (!this.commands.containsKey(c)) {
      return;
    }
    TurtleCommand cmd = (TurtleCommand)this.commands.get(c);
    cmd.run(this);    
  }
  
  TurtleState getState() {
    return new TurtleState(this.position.get(), this.heading);
  }
  
  void loadState(TurtleState s) {
    this.position.x = s.position.x;
    this.position.y = s.position.y;
    this.heading = s.heading;
  }
  
  void fork() {
    this.history.push(this.getState());
  }

  void unfork() {
    TurtleState s = (TurtleState)this.history.pop();
    this.loadState(s);
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

TurtleCommand fork = new TurtleCommand() {
  public void run(Turtle t) {
    t.fork();
  }
};

TurtleCommand unfork = new TurtleCommand() {
  public void run(Turtle t) {
    t.unfork();
  }
};
