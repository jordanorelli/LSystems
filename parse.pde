PredicateParseRule[] PredicateParseRules;

void setupParseRules() {
  PredicateParseRules = new PredicateParseRule[]{
    parseMatch,
    parseLeftMatch,
    parseRightMatch
  };
}

abstract class ParseRule {
  abstract boolean parse(LSystem sys, String[] tokens);
}
