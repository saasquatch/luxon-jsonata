import { DateTime, Duration } from "luxon";
import { Expression } from "jsonata";

function getProperties(clazz: { [key: string]: any }) {
  return Object.getOwnPropertyNames(clazz)
    .filter((p) => !["prototype", "name", "length"].includes(p))
    .reduce((props, p) => {
      props[p] = clazz[p];
      return props;
    }, {} as { [key: string]: any });
}

export default function addLuxon(jsonata: Expression) {
  if (
    !jsonata ||
    !jsonata.hasOwnProperty("assign") ||
    !(typeof jsonata.assign === "function")
  ) {
    throw new Error(
      "`jsonata` doesn't appear to be a valid JSONata expression object"
    );
  }

  jsonata.assign("DateTime", getProperties(DateTime));
  jsonata.assign("Duration", getProperties(Duration));
}
