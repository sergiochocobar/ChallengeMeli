//
//  SpaceFlightRepository.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation


class SpaceFlightRepository: SpaceFlightRepositoryProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func listArticles(limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: limit, offset: offset)
        let listDTO: ArticleListDTO = try await networkClient.request(endpoint: endpoint)
        return listDTO
    }
    
    func searchArticles(query: String, limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: query, limit: limit, offset: offset)
        let listDTO: ArticleListDTO = try await networkClient.request(endpoint: endpoint)
        return listDTO
    }

    func getArticleDetail(id: Int) async throws -> ArticleDetailDTO {
        let endpoint = SpaceFlightEndpoint.getArticleDetail(id: id)
        let detailDTO: ArticleDetailDTO = try await networkClient.request(endpoint: endpoint)
        return detailDTO
    }
}
