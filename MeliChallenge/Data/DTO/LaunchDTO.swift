//
//  LaunchDTO.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation

struct LaunchDTO: Codable {
    let launchId: String?
    let provider: String?

    enum CodingKeys: String, CodingKey {
        case launchId = "launch_id"
        case provider
    }
}
