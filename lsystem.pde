interface Production {
  String successor();
}

// deterministic production
class DProduction implements Production {
  private String s;
  DProduction(String s) { 
    this.s = s;
  }
  String successor() { 
    return this.s;
  }
}

// This shit is getting verbose.
class SPSuccessor {
  float probability;
  String successor;

  SPSuccessor(String successor, float probability) {
    this.probability = probability;
    this.successor = successor;
  }
}

// stochastic production
class SProduction implements Production {
  ArrayList<SPSuccessor> successors;
  SProduction(String successor, float probability) {
    this.successors = new ArrayList<SPSuccessor>();
    this.add(successor, probability);
  }
  String successor() {
    float n = random(1.0);
    for (SPSuccessor s : this.successors) {
      if (n < s.probability) {
        return s.successor;
      }
      n -= s.probability;
    }
    println("well, fuck it."); 
    exit(); 
    return "";
  }
  void add(String successor, float probability) {
    this.successors.add(new SPSuccessor(successor, probability));
  }
}

class LSystem {
  private HashMap productions;

  LSystem() {
    this.productions = new HashMap();
  }

  public void rule(char c, String out) {
    this.productions.put(c, new DProduction(out)); 
  }

  public void rule(char c, String out, float probability) {
    if (this.productions.containsKey(c)) {
      SProduction p = (SProduction)this.productions.get(c);
      p.add(out, probability);
    } else {
      this.productions.put(c, new SProduction(out, probability));      
    }
  }

  public String gen(String axiom, int n) {
    for (int i = 0; i < n; i++) {
      axiom = this.genOne(axiom);
    }
    return axiom;
  }

  private String genOne(String axiom) {
    StringBuffer buf = new StringBuffer();
    for (int i = 0; i < axiom.length(); i++) {
      char c = axiom.charAt(i);
      if (!this.productions.containsKey(c)) {
        buf.append(c);
        continue;
      }
      Production p = (Production)this.productions.get(c);
      buf.append(p.successor());
    }
    return buf.toString();
  }
}

