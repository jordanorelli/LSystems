interface Production {
  // whether to accept the character at index "index"
  // as seen in the string "axiom"
  boolean accept(String axiom, int index);
  String successor();
}

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

// This shit is getting verbose.
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
    this.successors = new ArrayList<SPSuccessor>();
  }

  boolean accept(String axiom, int index) {
    return this.pred == axiom.charAt(index);
  }

  String successor() {
    float n = random(1.0);
    for (SPSuccessor s : this.successors) {
      if (n < s.probability) {
        return s.succ;
      }
      n -= s.probability;
    }
    return this.successor();
  }

  void add(String successor, float probability) {
    this.successors.add(new SPSuccessor(successor, probability));
  }
}

class LSystem {
  private ArrayList<Production> productions;

  LSystem() {
    this.productions = new ArrayList<Production>();
  }
  
  public void rule(Production p) {
    this.productions.add(p);
  }
  
  public void rule(char predecessor, String successor) {
    this.productions.add(new DProduction(predecessor, successor));
  }

  public String gen(String axiom, int n) {
    for (int i = 0; i < n; i++) {
      axiom = this.genOne(axiom);
    }
    return axiom;
  }

  private Production production(String axiom, int index) {
    for (Production p : this.productions) {
      if (p.accept(axiom, index)) {
        return p;
      }
    }
    return null;
  }

  private String genOne(String axiom) {
    StringBuffer buf = new StringBuffer();

    for (int i = 0; i < axiom.length(); i++) {
      Production p = this.production(axiom, i);
      if (p != null) {
        buf.append(p.successor());
      } 
      else {
        buf.append(axiom.charAt(i));
      }
    }

    return buf.toString();
  }
}

