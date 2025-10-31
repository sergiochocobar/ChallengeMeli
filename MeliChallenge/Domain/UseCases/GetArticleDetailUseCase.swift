//
//  GetArticleDetailUseCase.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation

protocol GetArticleDetailUseCaseProtocol {
    func execute(id: Int) async throws -> ArticleModel
}

class GetArticleDetailUseCase: GetArticleDetailUseCaseProtocol {
    private let repository: SpaceFlightRepositoryProtocol
    
    init(repository: SpaceFlightRepositoryProtocol = SpaceFlightRepository()) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> ArticleModel {
        let detailDTO = try await repository.getArticleDetail(id: id)
        
        return ArticleModel(
            id: detailDTO.id,
            title: detailDTO.title,
            imageUrl: detailDTO.imageUrl,
            newsSite: detailDTO.newsSite,
            summary: detailDTO.summary,
            url: detailDTO.url,
            publishedAt: detailDTO.publishedAt.toSpaceFlightDate(),
            authors: detailDTO.authors?.map { $0.name } ?? [],
            launches: detailDTO.launches?.compactMap { $0.provider } ?? []
        )
    }
}
