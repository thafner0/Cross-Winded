//
//  Wind.swift
//  Cross-Winded
//
//  Created by Trevor Hafner on 1/1/26.
//

import Foundation
import RegexBuilder

nonisolated struct Wind: Hashable {
    var directionDegrees: Double
    var speedKnots: Double
    var gustKnots: Double? = nil
    
    struct FormatStyle: ParseableFormatStyle {
        var parseStrategy: Strategy = Strategy()
        
        func format(_ value: Wind) -> String {
            let degreeFormat = FloatingPointFormatStyle<Double>.number
                .rounded(increment: 1)
                .precision(.integerLength(3))
            
            let speedFormat = FloatingPointFormatStyle<Double>.number
                .rounded(increment: 1)
                .precision(.integerLength(2...3))
            
            var base = "\(value.directionDegrees.formatted(degreeFormat))\(value.speedKnots.formatted(speedFormat))"
            if let gustKnots = value.gustKnots {
                base += "G\(gustKnots.formatted(speedFormat))"
            }
            return base + "KT"
        }
        
        struct Strategy: ParseStrategy {
            var isLenient = true
            
            func parse(_ value: String) throws -> Wind {
                let regex = Regex {
                    Capture(Repeat(.digit, count: 3)) { match in
                        guard let value = Double(match) else {
                            throw ParseError.unexpectedNonDigitEncountered
                        }
                        return value
                    }
                    Capture {
                        Repeat(.digit, 2...3)
                    } transform: { match in
                        guard let value = Double(match) else {
                            throw ParseError.unexpectedNonDigitEncountered
                        }
                        return value
                    }
                    Optionally {
                        "G"
                        Capture {
                            Repeat(.digit, 2...3)
                        } transform: { match in
                            guard let value = Double(match) else {
                                throw ParseError.unexpectedNonDigitEncountered
                            }
                            return value
                        }
                    }
                    Repeat("KT", (isLenient ? 0 : 1)...1)
                }
                
                guard let match = try regex.wholeMatch(in: value) else {
                    throw ParseError.inputInUnexpectedFormat
                }
                
                let windDirection = match.1
                let windSpeed = match.2
                let gustSpeed = match.3
                
                return Wind(directionDegrees: windDirection, speedKnots: windSpeed, gustKnots: gustSpeed)
            }
            
            enum ParseError: Error {
                case unexpectedNonDigitEncountered
                case inputInUnexpectedFormat
            }
        }
    }
}


