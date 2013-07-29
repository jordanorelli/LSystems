// matches a character at a position in a string
interface Predicate {
  boolean accept(Context context, String axiom, int index);
}

// parses a predicate function from an array of tokens.
// that is, gets a predicate from a string like "a < b" or "b > a"
abstract class PredicateParseRule {
  abstract Predicate parse(LSystem sys, String []tokens);
}

class PredicatePair implements Predicate {
  private Predicate left;
  private Predicate right;

  PredicatePair(Predicate left, Predicate right) {
    this.left = left;
    this.right = right;
  }

  public boolean accept(Context context, String axiom, int index) {
    return this.left.accept(context, axiom, index) && this.right.accept(context, axiom, index);
  }

  String toString() {
    return String.format("{%s, %s}", this.left, this.right);
  }
}

interface Successor {
  String successor();
}

abstract class SuccessorParseRule {
  abstract Successor parse(LSystem sys, String []tokens);
}

class Production {
  private Predicate pred;
  private Successor succ;

  Production(Predicate pred, Successor succ) {
    this.pred = pred;
    this.succ = succ;
  }

  public boolean accept(Context context, String axiom, int index) {
    return this.pred.accept(context, axiom, index);
  }

  public String successor() {
    return this.succ.successor();
  }

  public void addOption(StochasticOption option) {
    Stochastic s = (Stochastic)this.succ;
    s.add(option);
  }

  public String toString() {
    return this.pred.toString();
  }
}
