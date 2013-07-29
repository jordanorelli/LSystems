class LSystem {
  public ArrayList<Production> productions;
  private Context context;
  private HashMap<String, Production> parseCache;

  LSystem() {
    this.productions = new ArrayList<Production>();
    this.context = new Context();
    this.parseCache = new HashMap<String, Production>();
  }

  LSystem(String ignore) {
    this.productions = new ArrayList<Production>();
    this.context = new Context(ignore);
    this.parseCache = new HashMap<String, Production>();
  }

  public void rule(Production p) {
    this.productions.add(p);
  }

  public String gen(String axiom, int n) {
    for (int i = 0; i < n; i++) {
      axiom = this.genOne(axiom);
    }
    return axiom;
  }

  private Production match(String axiom, int index) {
    for (Production p : this.productions) {
      if (p.accept(this.context, axiom, index)) {
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
    String[] predicateTokens = null;
    String[] successorTokens = null;
    String[] tokens = splitTokens(production);
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].equals("->")) {
        predicateTokens = subset(tokens, 0, i);
        successorTokens = subset(tokens, i+1, tokens.length-i-1);
      }
    }

    switch (successorTokens.length) {
    case 1:
      this.addDProduction(predicateTokens, successorTokens);
      return true;

    case 2:
      this.addSProduction(predicateTokens, successorTokens);
      return true;
    }

    return false;
  }  

  private Predicate parsePredicate(String[] tokens) {
    Predicate out = null;
    for (PredicateParseRule p : PredicateParseRules) {
      Predicate pred = p.parse(this, tokens);
      if (pred == null) {
        continue;
      }
      if (out == null) {
        out = pred;
      } else {
        out = new PredicatePair(out, pred);
      }
    }
    return out;
  }

  private void addDProduction(String[] predicateTokens, String[] successorTokens) {
    Predicate pred = this.parsePredicate(predicateTokens);
    Successor succ = new Deterministic(successorTokens[0]);
    Production p = new Production(pred, succ);
    println(p);
    this.productions.add(p);
  }

  private void addSProduction(String[] predicateTokens, String[] successorTokens) {
    float prob = float(successorTokens[1]);
    StochasticOption option = new StochasticOption(successorTokens[0], prob);

    String cacheKey = join(predicateTokens, " ");
    if (this.parseCache.containsKey(cacheKey)) {
      Production p = this.parseCache.get(cacheKey);
      p.addOption(option);
      println(p);
      return;
    } else {
      Predicate pred = this.parsePredicate(predicateTokens);
      Successor succ = new Stochastic(option);
      Production p = new Production(pred, succ);
      this.parseCache.put(cacheKey, p);
      this.productions.add(p);
      println(p);
      return;
    }
  }
}

