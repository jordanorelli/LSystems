ArrayList<ParseRule> ParseRules = new ArrayList<ParseRule>();

void setupParseRules() {
  ParseRules.add(parseDProduction);
}

Production parse(String[] tokens) {
  for (ParseRule rule : ParseRules) {
    Production p = rule.parse(tokens);
    if (p != null) {
      return p;
    }
  }
  return null;
}

abstract class ParseRule {
  abstract Production parse(String[] tokens);
}
