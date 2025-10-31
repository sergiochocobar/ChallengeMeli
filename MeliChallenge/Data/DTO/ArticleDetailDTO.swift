//
//  ArticleDetailDTO.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation

struct ArticleDetailDTO: Codable {
    let id: Int
    let title: String
    let authors: [AuthorDTO]?
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
    let updatedAt: String
    let featured: Bool
    let launches: [LaunchDTO]?
    let events: [EventDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, authors, url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case featured, launches, events
    }
}
