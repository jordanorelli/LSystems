interface Production {
  // whether to accept the character at index "index"
  // as seen in the string "axiom"
  boolean accept(String axiom, int index);
  String successor();
}
