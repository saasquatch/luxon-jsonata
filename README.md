<h1 align="center">luxon-jsonata</h1>

<p align="center">JSONata bindings for the Luxon date library.</p>

<p align="center">
  <a href="https://www.npmjs.com/package/luxon-jsonata"><img src="https://img.shields.io/npm/v/luxon-jsonata/latest.svg?style=flat-square" alt="NPM version" /> </a>
  <a href="https://www.npmjs.com/package/luxon-jsonata"><img src="https://img.shields.io/npm/dm/luxon-jsonata.svg?style=flat-square" alt="NPM downloads"/> </a>
</p>

[JSONata](https://jsonata.org) is a great tool for transforming JSON data, but the date and time manipulation functions that it provides
are lacklustre. This package adds a simple binding for [Luxon's](https://moment.github.io/luxon/) `DateTime` and `Duration` objects so they can be
used directly in JSONata expressions.

## Getting Started

```ts
import addLuxon from "luxon-jsonata";
import jsonata from "jsonata";

const expr = jsonata(
  '$Duration.fromISO("P2M").plus({"months":3, "days":10}).toISO()'
);

addLuxon(expr);

console.log(expr.evaluate());

// Result is "P5M10D"
```

## Supporters

This package is supported by [SaaSquatch](https://saasquatch.com).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
