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
    
    @Test(arguments:
            zip(
                [
                    "27009KT",
                    "23014KT",
                    "01019KT",
                    "00902KT",
                    "360400KT",
                    "00000KT",
                    "000000KT",
                    "31015G25KT",
                    "01421G29KT",
                    "00315G24KT"
                ],
                [
                    Wind(directionDegrees: 270, speedKnots: 9),
                    Wind(directionDegrees: 230, speedKnots: 14),
                    Wind(directionDegrees: 10, speedKnots: 19),
                    Wind(directionDegrees: 9, speedKnots: 2),
                    Wind(directionDegrees: 360, speedKnots: 400),
                    Wind(directionDegrees: 0, speedKnots: 0),
                    Wind(directionDegrees: 0, speedKnots: 0),
                    Wind(directionDegrees: 310, speedKnots: 15, gustKnots: 25),
                    Wind(directionDegrees: 014, speedKnots: 21, gustKnots: 29),
                    Wind(directionDegrees: 3, speedKnots: 15, gustKnots: 24)
                ]
            )
    )
    func interpretValidWinds(input: String, expectedInterpretation: Wind) async throws {
        try #expect(formatStyle.parseStrategy.parse(input) == expectedInterpretation)
    }
    
    @Test(arguments:
            zip(
                [
                    "34504",
                    "05423",
                    "004320",
                    "00000",
                    "000000",
                    "23010G34",
                    "04324G45",
                    "000100G150"
                ],
                [
                    Wind(directionDegrees: 345, speedKnots: 4),
                    Wind(directionDegrees: 54, speedKnots: 23),
                    Wind(directionDegrees: 4, speedKnots: 320),
                    Wind(directionDegrees: 0, speedKnots: 0),
                    Wind(directionDegrees: 0, speedKnots: 0),
                    Wind(directionDegrees: 230, speedKnots: 10, gustKnots: 34),
                    Wind(directionDegrees: 43, speedKnots: 24, gustKnots: 45),
                    Wind(directionDegrees: 0, speedKnots: 100, gustKnots: 150)
                ]
            )
    )
    func lenientValidWindInterprettions(input: String, expectedInterpretation: Wind?) async throws {
        try #expect(formatStyle.parseStrategy.parse(input) == expectedInterpretation)
        
        let strictFormatStyle = Wind.FormatStyle(parseStrategy: Wind.FormatStyle.Strategy(isLenient: false))
        #expect(throws: Wind.FormatStyle.Strategy.ParseError.inputInUnexpectedFormat) {
            try strictFormatStyle.parseStrategy.parse(input)
        }
    }
    
    @Test(arguments:
            [
                "3351KT",
                "3334445KT",
                "33344G4",
                "333444G4",
                "22255G4444",
                "222555G4444",
                "2224433",
                "22244g43",
                "22244kt",
                "11133g43KT"
            ]
    )
    func invalidValues(input: String) async throws {
        #expect(throws: Wind.FormatStyle.Strategy.ParseError.inputInUnexpectedFormat) {
            try formatStyle.parseStrategy.parse(input)
        }
    }
    
    init() {
        self.formatStyle = Wind.FormatStyle()
    }
}
