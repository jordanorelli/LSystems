class LSystem {
  private HashMap productions;
  
  LSystem() {
    this.productions = new HashMap();
  }
  
  public void rule(char c, String out) {
    this.productions.put(c, out);
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
      buf.append((String)this.productions.get(c));
    }
    return buf.toString();
  }
}
