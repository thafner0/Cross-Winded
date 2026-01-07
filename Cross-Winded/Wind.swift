//
//  Wind.swift
//  Cross-Winded
//
//  Created by Trevor Hafner on 1/1/26.
//

import Foundation
import RegexBuilder

nonisolated struct Wind: Hashable {
    var northSouthComponent: Double
    var eastWestComponent: Double
    var gustMultiplier: Double? = nil
    
    struct FormatStyle: ParseableFormatStyle {
        var parseStrategy: Strategy = Strategy()
        
        func format(_ value: Wind) -> String {
            let degreeFormat = FloatingPointFormatStyle<Double>.number
                .rounded(increment: 1)
                .precision(.integerLength(3))
            
            let speedFormat = FloatingPointFormatStyle<Double>.number
                .rounded(increment: 1)
                .precision(.integerLength(2...3))
            
            let mathDegreeDirection: Double
            if value.eastWestComponent == 0 {
                mathDegreeDirection = value.northSouthComponent.sign == .minus ? 270 : 90
            } else {
                let initialDirection = atan(value.northSouthComponent / value.eastWestComponent) * 180 / .pi
                if value.eastWestComponent.sign == .minus {
                    mathDegreeDirection = initialDirection + 180
                } else {
                    mathDegreeDirection = initialDirection + 360
                }
            }
            
            let compassDegrees = (90 - mathDegreeDirection + 360).truncatingRemainder(dividingBy: 360)
            let speed = sqrt(value.northSouthComponent * value.northSouthComponent + value.eastWestComponent * value.eastWestComponent)
            let gustSpeed: Double?
            if let gustMultiplier = value.gustMultiplier {
                gustSpeed = speed * gustMultiplier
            } else {
                gustSpeed = nil
            }
            
            var base = "\(compassDegrees.formatted(degreeFormat))\(speed.formatted(speedFormat))"
            if let gustSpeed {
                base += "G\(gustSpeed.formatted(speedFormat))"
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
                
                return try Wind(directionDegrees: windDirection, speedKnots: windSpeed, gustKnots: gustSpeed)
            }
            
            enum ParseError: Error {
                case unexpectedNonDigitEncountered
                case inputInUnexpectedFormat
            }
        }
    }
    
    init(directionDegrees: Double, speedKnots: Double, gustKnots: Double? = nil) throws {
        guard (0...360).contains(directionDegrees) else {
            throw InconsistentValueError.directionValueOutOfBounds
        }
        guard speedKnots >= 0 else {
            throw InconsistentValueError.speedValueOutOfBounds
        }
        if let gustKnots {
            guard gustKnots >= speedKnots else {
                throw InconsistentValueError.gustSpeedValueLessThanStandardSpeedValue
            }
        }
        self.northSouthComponent = speedKnots * cos(.pi * directionDegrees / 180)
        self.eastWestComponent = speedKnots * sin(.pi * directionDegrees / 180)
        if let gustKnots, gustKnots != 0, gustKnots != speedKnots {
            self.gustMultiplier = gustKnots / speedKnots
        } else {
            self.gustMultiplier = nil
        }
    }
    
    enum InconsistentValueError: Error {
        case directionValueOutOfBounds
        case speedValueOutOfBounds
        case gustSpeedValueLessThanStandardSpeedValue
    }
}


