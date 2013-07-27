ArrayList<ParseRule> ParseRules = new ArrayList<ParseRule>();

void setupParseRules() {
  ParseRules.add(parseDProduction);
  ParseRules.add(parseSProduction);
  ParseRules.add(parseC10Production);
}

abstract class ParseRule {
  abstract boolean parse(LSystem sys, String[] tokens);
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

class C10Production implements Production {
  private char left;
  private char pred;
  private String succ;

  C10Production(char left, char pred, String succ) {
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

// a < b -> b
ParseRule parseC10Production = new ParseRule() {
  boolean parse(LSystem sys, String[] tokens) {
    if (tokens.length != 5
      ||  tokens[0].length() != 1
      || !tokens[1].equals("<")
      ||  tokens[2].length() != 1
      || !tokens[3].equals("->"))
      return false;
    sys.rule(new C10Production(tokens[0].charAt(0), tokens[2].charAt(0), tokens[4]));
    return true;
  }
};

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

  public void ruleLeft(char left, char pred, String succ) {
    this.productions.add(new C10Production(left, pred, succ));
  }

  public String gen(String axiom, int n) {
    for (int i = 0; i < n; i++) {
      axiom = this.genOne(axiom);
    }
    return axiom;
  }

  public Production match(String axiom, int index) {
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
      Production p = this.match(axiom, i);
      if (p != null) {
        buf.append(p.successor());
      } 
      else {
        buf.append(axiom.charAt(i));
      }
    }

    return buf.toString();
  }

  public boolean parse(String production) {
    String[] tokens = splitTokens(production);
    for (ParseRule parseFn : ParseRules) {
      if (parseFn.parse(this, tokens)) {
        return true;
      }
    }
    return false;
  }  
}

