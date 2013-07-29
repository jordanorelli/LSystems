class Match implements Predicate {
  private char c;

  Match(char c) {
    this.c = c;
  }

  boolean accept(Context context, String axiom, int index) {
    return index >= 0
      && index <= axiom.length()
      && axiom.charAt(index) == this.c;
  }

  String toString() {
    return String.format("{Match: %c}", this.c);
  }
}

PredicateParseRule parseMatch = new PredicateParseRule() {
  Predicate parse(LSystem sys, String []tokens, int index) {
    if (tokens[index].length() == 1) {
      return new Match(tokens[index].charAt(0));
    }
    return null;
  }
  Predicate parse(LSystem sys, String []tokens) {
    if (tokens.length == 1) {
      return this.parse(sys, tokens, 0);
    }
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].equals("<")) {
        return this.parse(sys, tokens, i+1);
      }
      if (tokens[i].equals(">")) {
        return this.parse(sys, tokens, i-1);
      }
    }
    return null;
  }
};


