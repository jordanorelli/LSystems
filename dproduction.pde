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
  Production parse(String[] tokens) {
    if (tokens.length != 3) {
      return null;
    }
    if (!tokens[1].equals("->")) {
      return null;
    }
    if (tokens[0].length() != 1) {
      return null;
    }
    
    char pred = tokens[0].charAt(0);
    String succ = tokens[2];
    println("<DProduction: " + pred + " " + succ + ">");
    return new DProduction(tokens[0].charAt(0), tokens[2]);
  }
};
