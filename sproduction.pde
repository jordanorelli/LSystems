class SPSuccessor {
  float probability;
  String succ;

  SPSuccessor(String succ, float probability) {
    this.probability = probability;
    this.succ = succ;
  }
}

// stochastic production, context-free
class SProduction implements Production {
  private ArrayList<SPSuccessor> successors;
  private char pred;

  SProduction(char pred) {
    this.pred = pred;
  }

  boolean accept(String axiom, int index) {
    return this.pred == axiom.charAt(index);
  }

  String successor() {
    if (this.successors == null) {
      return "";
    }
    float n = random(1.0);
    for (SPSuccessor s : this.successors) {
      if (n < s.probability) {
        return s.succ;
      }
      n -= s.probability;
    }
    return "";
  }

  void add(String successor, float probability) {
    if (this.successors == null) {
      this.successors = new ArrayList<SPSuccessor>();
    }
    this.successors.add(new SPSuccessor(successor, probability));
  }
}

// F -> F[+F]-F 0.33
ParseRule parseSProduction = new ParseRule() {
  boolean parse(LSystem sys, String[] tokens) {
    SProduction sp;

    if (tokens.length != 4) {
      return false;
    }
    if (!tokens[1].equals("->")) {
      return false;
    }
    if (tokens[0].length() != 1) {
      return false;
    }

    Production p = sys.match(tokens[0], 0);
    if (p == null) {
      char pred = tokens[0].charAt(0);
      sp = new SProduction(pred);
      sys.rule(sp);
    } else {
      sp = (SProduction)p;
      // ummmmm, how do I guard against errors here?
    }
    sp.add(tokens[2], parseFloat(tokens[3]));
    return true;
  }
};
