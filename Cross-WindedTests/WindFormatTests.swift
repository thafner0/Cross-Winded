//
//  Cross_WindedTests.swift
//  Cross-WindedTests
//
//  Created by Trevor Hafner on 1/1/26.
//

import Testing
@testable import Cross_Winded

struct WindFormatTests {
    let formatStyle: Wind.FormatStyle
    
    @Test(arguments:
            zip(
                [
                    Wind(directionDegrees: 24, speedKnots: 23, gustKnots: 45),
                    Wind(directionDegrees: 250, speedKnots: 2, gustKnots: 5),
                    Wind(directionDegrees: 009, speedKnots: 150, gustKnots: 342),
                    Wind(directionDegrees: 171, speedKnots: 7, gustKnots: 23),
                    Wind(directionDegrees: 65, speedKnots: 8, gustKnots: 255),
                    Wind(directionDegrees: 87, speedKnots: 89, gustKnots: 101),
                    Wind(directionDegrees: 210, speedKnots: 5, gustKnots: nil),
                    Wind(directionDegrees: 034, speedKnots: 18, gustKnots: nil),
                    Wind(directionDegrees: 145, speedKnots: 330, gustKnots: nil)
                ],
                [
                    "02423G45KT",
                    "25002G05KT",
                    "009150G342KT",
                    "17107G23KT",
                    "06508G255KT",
                    "08789G101KT",
                    "21005KT",
                    "03418KT",
                    "145330KT"
                ]
            )
    )
    func formatIntoMETAR(wind: Wind, expectedString: String) async throws {
        #expect(formatStyle.format(wind) == expectedString)
    }

    init() {
        self.formatStyle = Wind.FormatStyle()
    }
}
