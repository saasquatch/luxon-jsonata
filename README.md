<h1 align="center">luxon-jsonata</h1>

<p align="center">JSONata bindings for the Luxon date library.</p>

<p align="center">
  <a href="https://www.npmjs.com/package/luxon-jsonata"><img src="https://img.shields.io/npm/v/luxon-jsonata/latest.svg?style=flat-square" alt="NPM version" /> </a>
  <a href="https://www.npmjs.com/package/luxon-jsonata"><img src="https://img.shields.io/npm/dm/luxon-jsonata.svg?style=flat-square" alt="NPM downloads"/> </a>
</p>

[JSONata](https://jsonata.org) is a great tool for transforming JSON data, but the date and time manipulation functions that it provides
are lacklustre. This package adds a simple binding for [Luxon's](https://moment.github.io/luxon/) `DateTime`, `Duration` and `Interval` objects so they can be
used directly in JSONata expressions.

## Getting Started

```ts
import addLuxon from "luxon-jsonata";
import jsonata from "jsonata";

const expr = jsonata(
  '$Duration.fromISO("P2M").plus({"months":3, "days":10}).toISO()'
);

addLuxon(expr);

console.log(expr.evaluate({}));

// Result is "P5M10D"
```

## Caveats

Not all methods are going to work. In particular, methods that themselves take functions, or require a standard Date
object are a bit awkward to use in JSONata. Perhaps in future we can dynamically remove these from the bound objects.

For Luxon member functions that themselves take functions, like `Duration.mapUnits`, you can assign a Javascript
function to the expression that takes the object and performs the operation you need:

```ts
const double = (x: Duration) => x.mapUnits((u) => u * 2);

const expr = jsonata(
  "$double($Duration.fromObject({ 'hours': 1, 'minutes': 30 })).toObject()"
);

addLuxon(expr);
expr.assign("double", double);

console.log(expr.evaluate({}));

// Result is { hours: 2, minutes: 60 }
```

## Supporters

This package is supported by [SaaSquatch](https://saasquatch.com).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
