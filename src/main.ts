import { DateTime, Duration } from "luxon";

export default function addLuxon(jsonata: any) {
  if (!jsonata || !jsonata.hasOwnProperty("registerFunction")) {
    return;
  }

  jsonata.registerFunction("DateTime", { ...DateTime });
  jsonata.registerFunction("Duration", { ...Duration });
}
