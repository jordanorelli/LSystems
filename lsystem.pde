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

static class Context {
  
  public static boolean matchLeft(String axiom, int index, char c) {
    int left_i = Context.left(axiom, index);
    if (left_i == -1) {
      return false;
    }
    return axiom.charAt(left_i) == c;
  }  
  
  private static boolean ignore(char c) {
    return c == '+' || c == '-';
  }
  
  private static boolean keep(char c) {
    return !Context.ignore(c);
  }

  private static int left(String axiom, int index) {
    if (index < 1) {
      return -1;
    }
    int d = 0;
    for (int i = index - 1; i >= 0; i--) {
      char c = axiom.charAt(i);
      switch (c) {
      case '[':
        if (d > 0) {
          d--;
        }
        break;

      case ']':
        d++;
        break;

      default:
        if (d == 0 && Context.keep(c)) {
          return i;
        }
        break;
      }
    }
    return -1;
  }
}

class C_1_0_Production implements Production {
  private char left;
  private char pred;
  private String succ;

  C_1_0_Production(char left, char pred, String succ) {
    this.left = left;
    this.pred = pred;
    this.succ = succ;
  }

  boolean accept(String axiom, int index) {
    if (index < 1) {
      return false;
    }
    return axiom.charAt(index) == this.pred && Context.matchLeft(axiom, index, this.left);
  }

  String successor() {
    return this.succ;
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
  
//  public void rule(char left, char pred, char right, String succ) {
//    this.productions.add(new C_1_1_Production(left, pred, succ));
//  }
  
  public void ruleLeft(char left, char pred, String succ) {
    this.productions.add(new C_1_0_Production(left, pred, succ));
  }
  
//  public void ruleRight(char pred, char right, String succ) {
//    this.productions.add(new C_0_1_Production(pred, right, succ));
//  }

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

