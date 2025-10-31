//
//  ArticleRepositoryProtocol.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation

protocol SpaceFlightRepositoryProtocol {
    func listArticles(limit: Int?, offset: Int?) async throws -> ArticleListDTO
    
    func searchArticles(query: String, limit: Int?, offset: Int?) async throws -> ArticleListDTO
    
    func getArticleDetail(id: Int) async throws -> ArticleDetailDTO
}
