import java.util.Stack;

boolean REPORT_MOVES = false;

class TurtleState {
  public PVector position;
  public float heading;

  TurtleState(PVector position, float heading) {
    this.position = position;
    this.heading = heading;
  }
}

public class Turtle {
  public TurtleState initialState;
  public PVector position; // current drawhead
  public float heading;
  public float stride;
  public float theta;
  private int born;
  private TurtleCommandSet commands;
  private Stack history;
  private PGraphics buf;
  
  Turtle(PApplet app, TurtleCommandSet commands, float stride, float theta, float heading) {
    this.buf = createGraphics(width, height, P2D);    
    this.stride = stride;
    this.theta = theta;
    if (commands == null) {
      this.commands = new TurtleCommandSet();
    } else {
      this.commands = commands;
    }
    this.heading = heading;
    this.setDefaultCommands();
    this.born = frameCount;
    this.history = new Stack();
    this.clear();
    this.register(app);
  }

  Turtle(PApplet app, float x, float y, float heading, float stride, float theta) {
    this.buf = createGraphics(width, height, P2D);    
    this.stride = stride;
    this.theta = theta;
    this.commands = new TurtleCommandSet();
    this.setDefaultCommands();
    this.born = frameCount;
    this.history = new Stack();
    this.initialState = new TurtleState(new PVector(x, y), heading);
    this.clear();
    this.register(app);
  }
  
  public void register(PApplet app) {
    app.registerDraw(this);
    app.registerPost(this);
  }
  
  public void unregister(PApplet app) {
    app.unregisterDraw(this);
    app.unregisterPost(this);
  }

  public void setDefaultCommands() {
    this.cmd('F', drawForward);
    this.cmd('f', moveForward);
    this.cmd('-', turnRight);
    this.cmd('+', turnLeft);
    this.cmd('[', fork);
    this.cmd(']', unfork);
  } 

  public void run(String program) {
    println(program);
    this.buf.beginDraw();
    this.buf.background(255, 255, 255, 0);
    for (int i = 0; i < program.length(); i++) {
      char c = program.charAt(i);
      TurtleCommand cmd = this.commands.get(""+c);
      if (cmd == null) {
        continue;
      }
      cmd.run(this);
    }
    buf.endDraw();
  }
  
  public void run(String program, float x, float y) {
    this.initialState = new TurtleState(new PVector(x, y), this.heading);
    this.clear();
    this.run(program);
  }

  public void cmd(char c, TurtleCommand command) {
    this.commands.add(""+c, command);
  }

  private int age() {
    return frameCount - this.born + 1;
  }

  void draw() {
    if (this.buf != null) {
      image(this.buf, 0, 0);
    }
  }

  void post() {
    this.clear();
  }

  void clear() {
    if (this.history != null) {
      this.history.empty();
    }
    if (this.initialState != null) {      
      this.position = this.initialState.position.get();
      this.heading = this.initialState.heading;
    }
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
    if (this.history.size() <= 0) {
      return;
    }
    TurtleState s = (TurtleState)this.history.pop();
    this.loadState(s);
  }
}

abstract class TurtleCommand {
  public abstract String name();
  public abstract void run(Turtle t);
}

// this is the type of shit you have to resort to when you don't have closures.
class CompositeTurtleCommand extends TurtleCommand {
  private TurtleCommand left;
  private TurtleCommand right;

  CompositeTurtleCommand(TurtleCommand left, TurtleCommand right) {
    this.left = left;
    this.right = right;
  }
  
  public String name() {
    return this.left.name() + " " + this.right.name();
  }

  public void run(Turtle t) {
    this.left.run(t);
    this.right.run(t);
  }
}

TurtleCommand drawForward = new TurtleCommand() {
  public String name() {
    return "drawForward";
  }
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("draw forward");
    }
    float x = t.position.x + t.stride * cos(t.heading);
    float y = t.position.y - t.stride * sin(t.heading);
    t.buf.stroke(0);
    t.buf.strokeWeight(2);    
    t.buf.line(t.position.x, t.position.y, x, y);
    t.position.x = x;
    t.position.y = y;
  }
};

TurtleCommand drawForwardRed = new TurtleCommand() {
  public String name() {
    return "drawForwardRed";
  }
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("draw forward");
    }
    float x = t.position.x + t.stride * cos(t.heading);
    float y = t.position.y - t.stride * sin(t.heading);
    t.buf.stroke(255,0,0);
    t.buf.strokeWeight(2);    
    t.buf.line(t.position.x, t.position.y, x, y);
    t.position.x = x;
    t.position.y = y;    
  }
};

TurtleCommand moveForward = new TurtleCommand() {
  public String name() {
    return "moveForward";
  }
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("move forward");
    }
    t.position.x += t.stride * cos(t.heading);
    t.position.y -= t.stride * sin(t.heading);
  }
};

TurtleCommand turnLeft = new TurtleCommand() {
  public String name() {
    return "turnLeft";
  }
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("turn left");
    }
    t.heading += t.theta;
  }
};

TurtleCommand turnRight = new TurtleCommand() {
  public String name() {
    return "turnRight";
  }
  public void run(Turtle t) {
    if (REPORT_MOVES) {
      println("turn right");
    }
    t.heading -= t.theta;
  }
};

TurtleCommand fork = new TurtleCommand() {
  public String name() {
    return "fork";
  }
  public void run(Turtle t) {
    t.fork();
  }
};

TurtleCommand unfork = new TurtleCommand() {
  public String name() {
    return "unfork";
  }
  public void run(Turtle t) {
    t.unfork();
  }
};

