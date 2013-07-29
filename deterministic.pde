class Deterministic implements Successor {
  private String s;
  Deterministic(String s) {
    this.s = s;
  }
  String successor() {
    return this.s;
  }
}

SuccessorParseRule parseDeterministic = new SuccessorParseRule() {
  Successor parse(LSystem sys, String []tokens) {
    return null;
  }
};


