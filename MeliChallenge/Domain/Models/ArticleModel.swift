//
//  ArticleModel.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation

struct ArticleModel: Identifiable, Hashable { 
    let id: Int
    let title: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let url: String
    let publishedAt: Date?
    let authors: [String]
    let launches: [String]
}


