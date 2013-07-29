class Context {
  private String ignore;

  Context() {
    this.ignore = "";
  }

  Context(String ignore) {
    println("ignore: " + ignore);
    this.ignore = ignore;
  }

  public boolean matchLeft(String axiom, int index, char c) {
    if (index > 0 && c == '*') {
      return true;
    }
    int left_i = this.left(axiom, index);
    if (left_i == -1) {
      return false;
    }
    return axiom.charAt(left_i) == c;
  }

  public boolean matchRight(String axiom, int index, char c) {
    if (index < axiom.length() - 1 && c == '*') {
      return true;
    }
    ArrayList<Integer> right = this.right(axiom, index);
    if (right == null) {
      return false;
    }
    for (int i : right) {
      if (axiom.charAt(i) == c) {
        return true;
      }
    }
    return false;
  }  

  private boolean ignore(char c) {
    return this.ignore.indexOf(c) != -1;
  }

  private boolean keep(char c) {
    return !this.ignore(c);
  }

  private int left(String axiom, int index) {
    if (index < 1) {
      return -1;
    }
    int d = 0;
    for (int i = index - 1; i >= 0; i--) {
      char c = axiom.charAt(i);
      if (this.ignore(c)) {
        continue;
      }
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
        if (d == 0) {
          return i;
        }
        break;
      }
    }
    return -1;
  }

  private ArrayList<Integer> right(String axiom, int index) {
    if (index >= axiom.length() - 1 || index < 0) {
      return null;
    }
    ArrayList<Integer> found = new ArrayList<Integer>();
    int d = 0;
    for (int i = index+1; i < axiom.length(); i++) {
      char c = axiom.charAt(i);
      if (this.ignore(c)) {
        continue;
      }
      switch (c) {
      case '[':
        d++;
        break;
      case ']':
        d--;
        break;
      }
      int left = this.left(axiom, i);
      if (left == index) {
        found.add(i);
      } else if (d == 0) {
        break;
      }
    }
    return found;
  }
}

class LeftMatch implements Predicate {
  private char c;

  LeftMatch(String left) {
    this.c = left.charAt(0);
  }

  boolean accept(Context context, String axiom, int index) {
    return context.matchLeft(axiom, index, this.c);
  }

  String toString() {
    return String.format("{left: %c}", this.c);
  }
}

PredicateParseRule parseLeftMatch = new PredicateParseRule() {
  Predicate parse(LSystem sys, String []tokens) {
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].equals("<")) {
        return new LeftMatch(tokens[i-1]);
      }
    }
    return null;
  }
};

class RightMatch implements Predicate {
  private char c;

  RightMatch(String right) {
    this.c = right.charAt(0);
  }

  boolean accept(Context context, String axiom, int index) {
    return context.matchRight(axiom, index, this.c);
  }

  String toString() {
    return String.format("{right: %c}", this.c);
  }
}

PredicateParseRule parseRightMatch = new PredicateParseRule() {
  Predicate parse(LSystem sys, String []tokens) {
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i].equals(">")) {
        return new RightMatch(tokens[i+1]);
      }
    }
    return null;
  }
};
