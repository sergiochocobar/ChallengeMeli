//
//  ListArticlesUseCase.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation

protocol ListArticlesUseCaseProtocol {
    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel
}

class ListArticlesUseCase: ListArticlesUseCaseProtocol {
    private let repository: SpaceFlightRepositoryProtocol
    
    init(repository: SpaceFlightRepositoryProtocol = SpaceFlightRepository()) {
        self.repository = repository
    }
    
    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        let listDTO = try await repository.listArticles(limit: limit, offset: offset)
        
        return ArticleResponseModel(dto: listDTO)
    }
}
