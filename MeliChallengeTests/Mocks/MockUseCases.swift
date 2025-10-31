//
//  MockUseCases.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation
@testable import MeliChallenge

class MockListArticlesUseCase: ListArticlesUseCaseProtocol {
    var executeResult: Result<ArticleResponseModel, Error>?

    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        if let result = executeResult {
            return try result.get()
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
}

class MockSearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    var executeResult: Result<ArticleResponseModel, Error>?
    
    func execute(query: String, limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        if let result = executeResult {
            return try result.get()
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
}

class MockGetArticleDetailUseCase: GetArticleDetailUseCaseProtocol {
    var executeResult: Result<ArticleModel, Error>?
    
    func execute(id: Int) async throws -> ArticleModel {
        if let result = executeResult {
            return try result.get()
        }
        throw NetworkError.unknown(URLError(.badServerResponse))
    }
}
