Feature: Duration

    The goal of these tests is to confirm that most of the common operations on a Duration
    can be performed within a JSONata expression. They are not exhaustive on all the functionality
    of the Duration object, but give reasonable assurance that most things will work.

    Scenario Outline: Durations can be constructed with fromISO
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                               | result                                                                                       |
            | $Duration.fromISO('P3Y6M1W4DT12H30M5S').toObject() | { "years": 3, "months": 6, "weeks": 1, "days": 4, "hours": 12, "minutes": 30, "seconds": 5 } |
            | $Duration.fromISO('PT23H').toObject()              | { "hours": 23 }                                                                              |
            | $Duration.fromISO('P5Y3M').toObject()              | { "years": 5, "months": 3 }                                                                  |

    Scenario Outline: Durations can be constructed with fromISOTime
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                             | result                                                             |
            | $Duration.fromISOTime('11:22:33.444').toObject() | { "hours": 11, "minutes": 22, "seconds": 33, "milliseconds": 444 } |
            | $Duration.fromISOTime('T11:00').toObject()       | { "hours": 11, "minutes": 0, "seconds": 0 }                        |
            | $Duration.fromISOTime('1100').toObject()         | { "hours": 11, "minutes": 0, "seconds": 0 }                        |
            | $Duration.fromISOTime('T1100').toObject()        | { "hours": 11, "minutes": 0, "seconds": 0 }                        |

    Scenario: Durations can be constructed with fromMillis
        Given a JSONata expression:
            """
            $Duration.fromMillis(1000).toObject()
            """
        When the expression is evaluated
        Then the result will be:
            """
            {
                "milliseconds": 1000
            }
            """

    Scenario: Durations can be constructed with fromObject
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'years': 5, 'months': 3 }).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "P5Y3M"
            """

    Scenario: Invalid durations can be constructed
        Given a JSONata expression:
            """
            $Duration.invalid('invalid reason', 'invalid explanation').isValid
            """
        When the expression is evaluated
        Then the result will be:
            """
            false
            """

    Scenario: isDuration returns true on constructed Durations
        Given a JSONata expression:
            """
            ( $dur := $Duration.fromObject({ 'years': 5, 'months': 3 }); $Duration.isDuration($dur) )
            """
        When the expression is evaluated
        Then the result will be:
            """
            true
            """

    Scenario Outline: Duration property accessors return the correct value
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                          | result                |
            | $Duration.fromObject({ 'days': 5 }).days                                      | 5                     |
            | $Duration.fromObject({ 'hours': 5 }).hours                                    | 5                     |
            | $Duration.fromObject({ 'milliseconds': 5 }).milliseconds                      | 5                     |
            | $Duration.fromObject({ 'minutes': 5 }).minutes                                | 5                     |
            | $Duration.fromObject({ 'months': 5 }).months                                  | 5                     |
            | $Duration.fromObject({ 'quarters': 5 }).quarters                              | 5                     |
            | $Duration.fromObject({ 'seconds': 5 }).seconds                                | 5                     |
            | $Duration.fromObject({ 'weeks': 5 }).weeks                                    | 5                     |
            | $Duration.fromObject({ 'years': 5 }).years                                    | 5                     |
            | $Duration.fromObject({ 'months': 5 }).isValid                                 | true                  |
            | $Duration.invalid('invalid reason', 'invalid explanation').invalidReason      | "invalid reason"      |
            | $Duration.invalid('invalid reason', 'invalid explanation').invalidExplanation | "invalid explanation" |

    Scenario Outline: The `as` method on Duration returns the correct result
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                            | result |
            | $Duration.fromObject({'years': 1}).as('days')   | 365    |
            | $Duration.fromObject({'years': 1}).as('months') | 12     |
            | $Duration.fromObject({'hours': 60}).as('days')  | 2.5    |

    Scenario: The `equals` method on Duration returns the correct result
        Given a JSONata expression:
            """
            (
            $a :=  $Duration.fromObject({'years': 1});
            $b :=  $Duration.fromObject({'years': 1});
            $a.equals($b)
            )
            """
        When the expression is evaluated
        Then the result will be:
            """
            true
            """

    Scenario Outline: The `get` method on Duration returns the correct result
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                          | result |
            | $Duration.fromObject({'years': 2, 'days': 3}).get('years')    | 2      |
            | $Duration.fromObject({'years': 2, 'months': 6}).get('months') | 6      |
            | $Duration.fromObject({'years': 2, 'days': 3}).get('days')     | 3      |

    Scenario: The `minus` method on Duration returns the correct result
        Given a JSONata expression:
            """
            (
            $a :=  $Duration.fromObject({'years': 2});
            $b :=  $Duration.fromObject({'years': 1});
            $a.minus($b).years
            )
            """
        When the expression is evaluated
        Then the result will be:
            """
            1
            """

    Scenario: The `negate` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 1, 'seconds': 30 }).negate().toObject()
            """
        When the expression is evaluated
        Then the result will be:
            """
            {
                "hours": -1,
                "seconds": -30
            }
            """

    Scenario Outline: The `normalize` method on Duration returns the correct result
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                         | result                         |
            | $Duration.fromObject({ 'years': 2, 'days': 5000 }).normalize().toObject()    | { "years": 15, "days": 255 }   |
            | $Duration.fromObject({ 'hours': 12, 'minutes': -45 }).normalize().toObject() | { "hours": 11, "minutes": 15 } |

    Scenario: The `plus` method on Duration returns the correct result
        Given a JSONata expression:
            """
            (
            $a :=  $Duration.fromObject({'years': 2});
            $b :=  $Duration.fromObject({'years': 1});
            $a.plus($b).years
            )
            """
        When the expression is evaluated
        Then the result will be:
            """
            3
            """

    Scenario: The `shiftTo` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 1, 'seconds': 30 }).shiftTo('minutes', 'milliseconds').toObject()
            """
        When the expression is evaluated
        Then the result will be:
            """
            {
                "minutes": 60,
                "milliseconds": 30000
            }
            """

    Scenario Outline: The `toFormat` method on Duration returns the correct result
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                                | result         |
            | $Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("y d s")     | "1 6 2"        |
            | $Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("yy dd sss") | "01 06 002"    |
            | $Duration.fromObject({ "years": 1, "days": 6, "seconds": 2 }).toFormat("M S")       | "12 518402000" |

    Scenario: The `toISO` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'years': 3, 'seconds': 45 }).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "P3YT45S"
            """

    Scenario Outline: The `toISOTime` method on Duration returns the correct result
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                              | result          |
            | $Duration.fromObject({ 'hours': 11 }).toISOTime()                                 | "11:00:00.000"  |
            | $Duration.fromObject({ 'hours': 11 }).toISOTime({ 'suppressMilliseconds': true }) | "11:00:00"      |
            | $Duration.fromObject({ 'hours': 11 }).toISOTime({ 'suppressSeconds': true })      | "11:00"         |
            | $Duration.fromObject({ 'hours': 11 }).toISOTime({ 'includePrefix': true })        | "T11:00:00.000" |
            | $Duration.fromObject({ 'hours': 11 }).toISOTime({ 'format': 'basic' })            | "110000.000"    |

    Scenario: The `toJSON` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 11 }).toJSON()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "PT11H"
            """

    Scenario: The `toMillis` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 11 }).toMillis()
            """
        When the expression is evaluated
        Then the result will be:
            """
            39600000
            """

    Scenario: The `toObject` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 11 }).toObject()
            """
        When the expression is evaluated
        Then the result will be:
            """
            {
                "hours": 11
            }
            """

    Scenario: The `toString` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 11 }).toString()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "PT11H"
            """

    Scenario: The `valueOf` method on Duration returns the correct result
        Given a JSONata expression:
            """
            $Duration.fromObject({ 'hours': 11 }).valueOf()
            """
        When the expression is evaluated
        Then the result will be:
            """
            39600000
            """
