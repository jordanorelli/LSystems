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
  private HashMap commands;
  private Stack history;
  private PGraphics buf;

  Turtle(PApplet app, float x, float y, float heading, float stride, float theta) {
    this.buf = createGraphics(width, height, P2D);    
    this.stride = stride;
    this.theta = theta;
    this.commands = new HashMap();
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
    this.cmd('r', drawForward);
    this.cmd('l', drawForward);
    this.cmd('[', fork);
    this.cmd(']', unfork);
  } 

  public void run(String program) {
    this.buf.beginDraw();
    this.buf.background(255, 255, 255, 0);
    for (int i = 0; i < program.length(); i++) {
      char c = program.charAt(i);
      if (!this.commands.containsKey(c)) {
        return;
      }
      TurtleCommand cmd = (TurtleCommand)this.commands.get(c);
      cmd.run(this);
    }
    buf.endDraw();
  }

  public void cmd(char c, TurtleCommand command) {
    this.commands.put(c, command);
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
  public abstract void run(Turtle t);
}

TurtleCommand drawForward = new TurtleCommand() {
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

