PredicateParseRule[] PredicateParseRules;
SuccessorParseRule[] SuccessorParseRules;

void setupParseRules() {
  PredicateParseRules = new PredicateParseRule[]{
    parseMatch,
    parseLeftMatch,
    parseRightMatch
  };
  SuccessorParseRules = new SuccessorParseRule[]{
    parseDeterministic,
    parseStochastic
  };
}

abstract class ParseRule {
  abstract boolean parse(LSystem sys, String[] tokens);
}
