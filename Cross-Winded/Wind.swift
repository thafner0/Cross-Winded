//
//  Wind.swift
//  Cross-Winded
//
//  Created by Trevor Hafner on 1/1/26.
//

import Foundation

nonisolated struct Wind: Hashable {
    var directionDegrees: Double
    var speedKnots: Double
    var gustKnots: Double? = nil
    
    struct FormatStyle: Foundation.FormatStyle {
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
    }
}


