//
//  EventDTO.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation

struct EventDTO: Codable {
    let eventId: Int
    let provider: String

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case provider
    }
}
