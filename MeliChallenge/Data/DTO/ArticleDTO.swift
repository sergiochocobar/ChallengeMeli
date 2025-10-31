//
//  ArticleDTO.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation 

struct ArticleListDTO: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ArticleDetailDTO]
}
