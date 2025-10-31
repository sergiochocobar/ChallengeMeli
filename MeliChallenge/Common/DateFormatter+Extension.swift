//
//  DateFormatter+Extension.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 31/10/2025.
//

import Foundation

extension ISO8601DateFormatter {
    static let spaceFlightFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        return formatter
    }()
}

extension String {
    func toSpaceFlightDate() -> Date? {
        return ISO8601DateFormatter.spaceFlightFormatter.date(from: self)
    }
}
