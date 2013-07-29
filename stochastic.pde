class StochasticOption {
  float probability;
  String succ;

  StochasticOption(String succ, float probability) {
    this.probability = probability;
    this.succ = succ;
  }
}

class Stochastic implements Successor {
  private ArrayList<StochasticOption> options;

  Stochastic(StochasticOption option) {
    this.options = new ArrayList<StochasticOption>();
    this.options.add(option);
  }

  String successor() {
    float n = random(1.0);
    for (StochasticOption o : this.options) {
      if (n < o.probability) {
        return o.succ;
      }
      n -= o.probability;
    }
    println("FAILED TO GET A STOCHASTIC OPTION THAT'S REAL BAD");
    return "";
  }

  void add(StochasticOption option) {
    this.options.add(option);
  }
}

SuccessorParseRule parseStochastic = new SuccessorParseRule() {
  Successor parse(LSystem sys, String []tokens) {
    return null;
  }
};
