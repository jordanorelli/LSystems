// deterministic production
class DProduction implements Production {
  private char pred;
  private String succ;

  DProduction(char pred, String succ) { 
    this.succ = succ;
    this.pred = pred;
  }

  boolean accept(String axiom, int index) {
    return axiom.charAt(index) == this.pred;
  }

  String successor() { 
    return this.succ;
  }
}

ParseRule parseDProduction = new ParseRule() {
  boolean parse(LSystem sys, String[] tokens) {
    if (tokens.length != 3) {
      return false;
    }
    if (!tokens[1].equals("->")) {
      return false;
    }
    if (tokens[0].length() != 1) {
      return false;
    }
    char pred = tokens[0].charAt(0);
    String succ = tokens[2];
    sys.rule(new DProduction(tokens[0].charAt(0), tokens[2]));
    return true;
  }
};
