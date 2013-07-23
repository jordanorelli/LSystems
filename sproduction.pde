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
