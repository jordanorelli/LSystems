TurtleCommandSet commands;

class TurtleCommandSet {
  private HashMap<String, TurtleCommand>cmds;
  
  TurtleCommandSet() {
    this.cmds = new HashMap<String, TurtleCommand>();
  }
  
  TurtleCommandSet(JSONObject json) {
    this.cmds = new HashMap<String, TurtleCommand>();
    for (Object keyObj : json.keys()) {
      String name = (String)keyObj;
      TurtleCommand cmd = commands.get(json.getString(name));
      if (cmd == null) {
        println("unable to get json command name: " + name);
        continue;
      }
      this.add(name, cmd);
    }
  }
  
  public void add(TurtleCommand t) {
    this.cmds.put(t.name(), t);
  }
  
  public void add(String name, TurtleCommand t) {
    this.cmds.put(name, t);
  }
  
  public TurtleCommand get(String name) {
    if (this.cmds.containsKey(name)) {
      return this.cmds.get(name);
    }
    return null;
  }
}

void setupTurtleCommands() {
  commands = new TurtleCommandSet();
  commands.add(drawForward);
  commands.add(drawForwardRed);
  commands.add(moveForward);
  commands.add(turnLeft);
  commands.add(turnRight);
  commands.add(fork);
  commands.add(unfork);
}

