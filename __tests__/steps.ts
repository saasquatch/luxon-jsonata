import { StepDefinitions } from "jest-cucumber";
import jsonata from "jsonata";

import addLuxon from "../src/main";

const steps: StepDefinitions = ({ given, when, then }) => {
  let parsed: any = null;
  let result: any = null;

  beforeEach(() => {
    parsed = null;
    result = null;
  });

  given(/a JSONata expression (.*)/, (expr) => {
    parsed = jsonata(expr);
    addLuxon(parsed);
  });

  given(/a JSONata expression:/, (expr) => {
    parsed = jsonata(expr);
    addLuxon(parsed);
  });

  when("the expression is evaluated", () => {
    result = parsed.evaluate({});
  });

  then(/the result will be (.*)/, (expected) => {
    expect(result).toStrictEqual(JSON.parse(expected));
  });

  then("the result will be:", (expected) => {
    expect(result).toStrictEqual(JSON.parse(expected));
  });
};

export default steps;
