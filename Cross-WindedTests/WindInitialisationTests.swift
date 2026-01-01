//
//  WindInitialisationTests.swift
//  Cross-WindedTests
//
//  Created by Trevor Hafner on 1/1/26.
//

import Testing
@testable import Cross_Winded

struct WindInitialisationTests {
    
    @Test(arguments:
            zip(
                [
                    (450, 23, nil),
                    (570, 43, 50),
                    (123, -23, nil),
                    (334, -40, 10),
                    (094, 10, 5),
                    (243, 30, -20),
                ],
                [
                    Wind.InconsistentValueError.directionValueOutOfBounds,
                    .directionValueOutOfBounds,
                    .speedValueOutOfBounds,
                    .speedValueOutOfBounds,
                    .gustSpeedValueLessThanStandardSpeedValue,
                    .gustSpeedValueLessThanStandardSpeedValue,
                ]
            )
    )
    func initialiseInvalidValues(values: (Double, Double, Double?), expectedError: Wind.InconsistentValueError) async throws {
        #expect(throws: expectedError) {
            try Wind(directionDegrees: values.0, speedKnots: values.1, gustKnots: values.2)
        }
    }
    
    @Test(arguments:
            zip(
                [
                    (146, 15, 15),
                    (0, 0, 0),
                    (270, 15, 30),
                    (90, 18, nil)
                ],
                [
                    try Wind(directionDegrees: 146, speedKnots: 15, gustKnots: 15),
                    try Wind(directionDegrees: 0, speedKnots: 0, gustKnots: nil),
                    try Wind(directionDegrees: 270, speedKnots: 15, gustKnots: 30),
                    try Wind(directionDegrees: 90, speedKnots: 18, gustKnots: nil)
                ]
            )
    )
    func automaticGustNormalisation(values: (Double, Double, Double?), expectedValue: Wind) async throws {
        try #expect(Wind(directionDegrees: values.0, speedKnots: values.1, gustKnots: values.2) == expectedValue)
    }
    
    @Test func defaultGustValue() async throws {
        #expect(try (Wind(directionDegrees: 234, speedKnots: 56) == Wind(directionDegrees: 234, speedKnots: 56, gustKnots: nil)))
    }
}
