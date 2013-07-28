ArrayList<ParseRule> ParseRules = new ArrayList<ParseRule>();

void setupParseRules() {
  ParseRules.add(parseDProduction);
  ParseRules.add(parseSProduction);
  ParseRules.add(parseC10Production);
  ParseRules.add(parseC01Production);  
  ParseRules.add(parseC11Production);  
}

abstract class ParseRule {
  abstract boolean parse(LSystem sys, String[] tokens);
}

class LSystem {
  private ArrayList<Production> productions;
  private ContextScanner context;

  LSystem() {
    this.productions = new ArrayList<Production>();
    this.context = new ContextScanner();
  }

  LSystem(String ignore) {
    this.productions = new ArrayList<Production>();
    this.context = new ContextScanner(ignore);
  }

  public boolean matchLeft(String axiom, int index, char c) {
    return this.context.matchLeft(axiom, index, c);
  }

  public boolean matchRight(String axiom, int index, char c) {
    return this.context.matchRight(axiom, index, c);
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

