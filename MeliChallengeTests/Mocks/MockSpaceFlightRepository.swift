//
//  MockSpaceFlightRepository.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation
@testable import MeliChallenge

class MockSpaceFlightRepository: SpaceFlightRepositoryProtocol {
    var listArticlesResult: Result<ArticleListDTO, Error>?
    var searchArticlesResult: Result<ArticleListDTO, Error>?
    var getArticleDetailResult: Result<ArticleDetailDTO, Error>?

    func listArticles(limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        if let result = listArticlesResult {
            switch result {
            case .success(let dto):
                return dto
            case .failure(let error):
                throw error
            }
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
    
    func searchArticles(query: String, limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        if let result = searchArticlesResult {
            return try result.get()
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
    
    func getArticleDetail(id: Int) async throws -> ArticleDetailDTO {
        if let result = getArticleDetailResult {
            return try result.get()
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
}
