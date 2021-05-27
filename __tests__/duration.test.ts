import { Duration } from "luxon";
import jsonata from "jsonata";

import addLuxon from "../src/main";

function expectExpr(
  expr: string,
  result: any,
  assigns?: { [key: string]: any }
) {
  const parsed = jsonata(expr);
  addLuxon(parsed);
  if (assigns) {
    Object.keys(assigns).forEach((k) => parsed.assign(k, assigns[k]));
  }
  expect(parsed.evaluate({})).toStrictEqual(result);
}

function expectExprs(exprs: { [key: string]: any }) {
  for (let expr of Object.keys(exprs)) {
    expectExpr(expr, exprs[expr]);
  }
}

describe("Duration construction", () => {
  test("can construct a Duration with fromISO", () => {
    expectExprs({
      "$Duration.fromISO('P3Y6M1W4DT12H30M5S').toObject()": {
        years: 3,
        months: 6,
        weeks: 1,
        days: 4,
        hours: 12,
        minutes: 30,
        seconds: 5,
      },
      "$Duration.fromISO('PT23H').toObject()": { hours: 23 },
      "$Duration.fromISO('P5Y3M').toObject()": { years: 5, months: 3 },
    });
  });

  test("can construct a Duration with fromISOTime", () => {
    expectExprs({
      "$Duration.fromISOTime('11:22:33.444').toObject()": {
        hours: 11,
        minutes: 22,
        seconds: 33,
        milliseconds: 444,
      },
      "$Duration.fromISOTime('11:00').toObject()": {
        hours: 11,
        minutes: 0,
        seconds: 0,
      },
      "$Duration.fromISOTime('T11:00').toObject()": {
        hours: 11,
        minutes: 0,
        seconds: 0,
      },
      "$Duration.fromISOTime('1100').toObject()": {
        hours: 11,
        minutes: 0,
        seconds: 0,
      },
      "$Duration.fromISOTime('T1100').toObject()": {
        hours: 11,
        minutes: 0,
        seconds: 0,
      },
    });
  });

  test("can construct a Duration with fromMillis", () => {
    expectExpr("$Duration.fromMillis(1000).toObject()", {
      milliseconds: 1000,
    });
  });

  test("can construct a Duration with fromObject", () => {
    expectExpr(
      "$Duration.fromObject({ 'years': 5, 'months': 3 }).toISO()",
      "P5Y3M"
    );
  });

  test("can construct an invalid Duration", () => {
    expectExpr(
      "$Duration.invalid('invalid reason', 'invalid explanation').isValid",
      false
    );
  });

  test("isDuration works on constructed Durations", () => {
    expectExpr(
      "( $dur := $Duration.fromObject({ 'years': 5, 'months': 3 }); $Duration.isDuration($dur) )",
      true
    );
  });
});

describe("Duration properties", () => {
  test("can access days", () => {
    expectExpr("$Duration.fromObject({ 'days': 5 }).days", 5);
  });
  test("can access hours", () => {
    expectExpr("$Duration.fromObject({ 'hours': 5 }).hours", 5);
  });
  test("can access milliseconds", () => {
    expectExpr("$Duration.fromObject({ 'milliseconds': 5 }).milliseconds", 5);
  });
  test("can access minutes", () => {
    expectExpr("$Duration.fromObject({ 'minutes': 5 }).minutes", 5);
  });
  test("can access months", () => {
    expectExpr("$Duration.fromObject({ 'months': 5 }).months", 5);
  });
  test("can access quarters", () => {
    expectExpr("$Duration.fromObject({ 'quarters': 5 }).quarters", 5);
  });
  test("can access seconds", () => {
    expectExpr("$Duration.fromObject({ 'seconds': 5 }).seconds", 5);
  });
  test("can access weeks", () => {
    expectExpr("$Duration.fromObject({ 'weeks': 5 }).weeks", 5);
  });
  test("can access years", () => {
    expectExpr("$Duration.fromObject({ 'years': 5 }).years", 5);
  });
  test("can access isValid", () => {
    expectExpr("$Duration.fromObject({ 'months': 5 }).isValid", true);
  });
  test("can access invalidReason", () => {
    expectExpr(
      "$Duration.invalid('invalid reason', 'invalid explanation').invalidReason",
      "invalid reason"
    );
  });
  test("can access invalidExplanation", () => {
    expectExpr(
      "$Duration.invalid('invalid reason', 'invalid explanation').invalidExplanation",
      "invalid explanation"
    );
  });
});

describe("Duration methods", () => {
  test("as", () => {
    expectExprs({
      "$Duration.fromObject({'years': 1}).as('days')": 365,
      "$Duration.fromObject({'years': 1}).as('months')": 12,
      "$Duration.fromObject({'hours': 60}).as('days')": 2.5,
    });
  });

  test("equals", () => {
    expectExpr(
      `(
     $a :=  $Duration.fromObject({'years': 1});
     $b :=  $Duration.fromObject({'years': 1});
     $a.equals($b)
   )`,
      true
    );
  });

  test("get", () => {
    expectExprs({
      "$Duration.fromObject({'years': 2, 'days': 3}).get('years')": 2,
      "$Duration.fromObject({'years': 2, 'months': 6}).get('months')": 6,
      "$Duration.fromObject({'years': 2, 'days': 3}).get('days')": 3,
    });
  });

  test("minus", () => {
    expectExpr(
      `(
     $a :=  $Duration.fromObject({'years': 2});
     $b :=  $Duration.fromObject({'years': 1});
     $a.minus($b).years
   )`,
      1
    );
  });

  test("negate", () => {
    expectExpr(
      `$Duration.fromObject({ 'hours': 1, 'seconds': 30 }).negate().toObject()`,
      { hours: -1, seconds: -30 }
    );
  });

  test("normalize", () => {
    expectExprs({
      "$Duration.fromObject({ 'years': 2, 'days': 5000 }).normalize().toObject()":
        { years: 15, days: 255 },
      "$Duration.fromObject({ 'hours': 12, 'minutes': -45 }).normalize().toObject()":
        { hours: 11, minutes: 15 },
    });
  });

  test("plus", () => {
    expectExpr(
      `(
     $a :=  $Duration.fromObject({'years': 2});
     $b :=  $Duration.fromObject({'years': 1});
     $a.plus($b).years
   )`,
      3
    );
  });

  test("shiftTo", () => {
    expectExpr(
      "$Duration.fromObject({ 'hours': 1, 'seconds': 30 }).shiftTo('minutes', 'milliseconds').toObject()",
      { minutes: 60, milliseconds: 30000 }
    );
  });

  test("mapUnits", () => {
    const double = (x: Duration) => x.mapUnits((u) => u * 2);
    expectExpr(
      "$double($Duration.fromObject({ 'hours': 1, 'minutes': 30 })).toObject()",
      { hours: 2, minutes: 60 },
      { double }
    );
  });

  test("toFormat", () => {
    expectExprs({
      '$Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("y d s")':
        "1 6 2",
      '$Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("yy dd sss")':
        "01 06 002",
      '$Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("M S")':
        "12 518402000",
    });
  });

  test("toISO", () => {
    expectExpr(
      "$Duration.fromObject({ 'years': 3, 'seconds': 45 }).toISO()",
      "P3YT45S"
    );
  });

  test("toISOTime", () => {
    expectExprs({
      "$Duration.fromObject({ 'hours': 11 }).toISOTime()": "11:00:00.000",
      "$Duration.fromObject({ 'hours': 11 }).toISOTime({ 'suppressMilliseconds': true })":
        "11:00:00",
      "$Duration.fromObject({ 'hours': 11 }).toISOTime({ 'suppressSeconds': true })":
        "11:00",
      "$Duration.fromObject({ 'hours': 11 }).toISOTime({ 'includePrefix': true })":
        "T11:00:00.000",
      "$Duration.fromObject({ 'hours': 11 }).toISOTime({ 'format': 'basic' })":
        "110000.000",
    });
  });

  test("toJSON", () => {
    expectExpr("$Duration.fromObject({ 'hours': 11 }).toJSON()", "PT11H");
  });

  test("toMillis", () => {
    expectExpr("$Duration.fromObject({ 'hours': 11 }).toMillis()", 39600000);
  });

  test("toObject", () => {
    expectExpr("$Duration.fromObject({ 'hours': 11 }).toObject()", {
      hours: 11,
    });
  });

  test("toString", () => {
    expectExpr("$Duration.fromObject({ 'hours': 11 }).toString()", "PT11H");
  });

  test("valueOf", () => {
    expectExpr("$Duration.fromObject({ 'hours': 11 }).valueOf()", 39600000);
  });
});
