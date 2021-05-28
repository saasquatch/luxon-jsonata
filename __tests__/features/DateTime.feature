Feature: DateTime

    The goal of these tests is to confirm that most of the common operations on a DateTime
    can be performed within a JSONata expression. They are not exhaustive on all the functionality
    of the DateTime object, but give reasonable assurance that most things will work.

    Scenario: DateTimes can be constructed with fromHTTP
        Given a JSONata expression:
            """
            $DateTime.fromHTTP('Sun, 06 Nov 1994 08:49:37 GMT').isValid
            """
        When the expression is evaluated
        Then the result will be:
            """
            true
            """

    Scenario Outline: DateTimes can be constructed with fromISO
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                          | result |
            | $DateTime.fromISO('2016-05-25T09:08:34.123').isValid                          | true   |
            | $DateTime.fromISO('2016-05-25T09:08:34.123+06:00').isValid                    | true   |
            | $DateTime.fromISO('2016-05-25T09:08:34.123+06:00', {'setZone': true}).isValid | true   |
            | $DateTime.fromISO('2016-05-25T09:08:34.123', {'zone': 'utc'}).zone.name       | "UTC"  |

    Scenario: DateTimes can be constructed with fromMillis
        Given a JSONata expression:
            """
            $DateTime.fromMillis(1000).toObject()
            """
        When the expression is evaluated
        Then the result will be:
            """
            {
                "day": 31,
                "hour": 16,
                "millisecond": 0,
                "minute": 0,
                "month": 12,
                "second": 1,
                "year": 1969
            }
            """

    Scenario: DateTimes can be constructed with fromObject
        Given a JSONata expression:
            """
            $DateTime.fromObject({ 'year': 1982, 'month': 5, 'day': 25}).toISODate()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "1982-05-25"
            """

    Scenario: DateTimes can be constructed with fromRFC2822
        Given a JSONata expression:
            """
            $DateTime.fromRFC2822('25 Nov 2016 13:23:12 GMT').toISODate()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2016-11-25"
            """

    Scenario: DateTimes can be constructed with fromSeconds
        Given a JSONata expression:
            """
            $DateTime.fromSeconds(10, {'zone': 'utc'}).toISOTime()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "00:00:10.000Z"
            """

    Scenario: DateTimes can be constructed with fromSQL
        Given a JSONata expression:
            """
            $DateTime.fromSQL('2017-05-15 09:12:34.342 America/Los_Angeles', { 'setZone': true }).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2017-05-15T09:12:34.342-07:00"
            """

    Scenario: Invalid DateTimes can be constructed
        Given a JSONata expression:
            """
            $DateTime.invalid('invalid reason', 'invalid explanation').isValid
            """
        When the expression is evaluated
        Then the result will be:
            """
            false
            """

    Scenario: isDateTime returns true on constructed DateTimes
        Given a JSONata expression:
            """
            ( $d := $DateTime.fromObject({ 'years': 1990, 'months': 1 }); $DateTime.isDateTime($d) )
            """
        When the expression is evaluated
        Then the result will be:
            """
            true
            """

    Scenario: DateTimes can be constructed with utc
        Given a JSONata expression:
            """
            $DateTime.utc(2017, 3, 12, 5, 45, 10, 765).toString()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2017-03-12T05:45:10.765Z"
            """

    Scenario Outline: DateTime property accessors return the correct value
        Given a JSONata expression <expr>
        When the expression is evaluated
        Then the result will be <result>

        Examples:
            | expr                                                                          | result                |
            | $DateTime.fromObject({ 'day': 5 }).day                                        | 5                     |
            | $DateTime.fromObject({ 'hour': 5 }).hour                                      | 5                     |
            | $DateTime.fromObject({ 'millisecond': 5 }).millisecond                        | 5                     |
            | $DateTime.fromObject({ 'minute': 5 }).minute                                  | 5                     |
            | $DateTime.fromObject({ 'month': 5 }).month                                    | 5                     |
            | $DateTime.fromObject({ 'second': 5 }).second                                  | 5                     |
            | $DateTime.fromObject({ 'weekNumber': 5 }).weekNumber                          | 5                     |
            | $DateTime.fromObject({ 'year': 5 }).year                                      | 5                     |
            | $DateTime.invalid('invalid reason', 'invalid explanation').invalidReason      | "invalid reason"      |
            | $DateTime.invalid('invalid reason', 'invalid explanation').invalidExplanation | "invalid explanation" |

    Scenario: The `min` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.min($DateTime.utc(2017, 3, 12, 5, 45, 10, 765), $DateTime.utc(2016, 3, 12, 5, 45, 10)).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2016-03-12T05:45:10.000Z"
            """

    Scenario: The `max` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.max($DateTime.utc(2017, 3, 12, 5, 45, 10, 765), $DateTime.utc(2016, 3, 12, 5, 45, 10)).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2017-03-12T05:45:10.765Z"
            """

    Scenario: The `equals` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.utc(2017, 3, 12, 5, 45, 10).equals($DateTime.utc(2017, 3, 12, 5, 45, 10))
            """
        When the expression is evaluated
        Then the result will be:
            """
            true
            """

    Scenario: The `diff` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.utc(2017, 3, 12, 5, 45, 10, 765).diff($DateTime.utc(2016, 3, 12, 5, 45, 10)).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "PT31536000.765S"
            """

    Scenario: The `minus` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.utc(2017, 3, 12, 5, 45, 10, 765).minus($Duration.fromISO('P1Y')).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2016-03-12T05:45:10.765Z"
            """

    Scenario: The `plus` method on DateTime returns the correct result
        Given a JSONata expression:
            """
            $DateTime.utc(2017, 3, 12, 5, 45, 10, 765).plus($Duration.fromISO('P1Y')).toISO()
            """
        When the expression is evaluated
        Then the result will be:
            """
            "2018-03-12T05:45:10.765Z"
            """

