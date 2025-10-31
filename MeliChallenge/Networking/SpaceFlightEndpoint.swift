//
//  SpaceFlightEndpoint.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation

enum SpaceFlightEndpoint: Endpoint {
    case listArticles(limit: Int?, offset: Int?)
    case searchArticles(query: String, limit: Int?, offset: Int?)
    case getArticleDetail(id: Int)

    var path: String {
        switch self {
        case .listArticles, .searchArticles:
            return "/articles/"
         case .getArticleDetail(let id):
             return "/articles/\(id)/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listArticles, .searchArticles, .getArticleDetail:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        
        switch self {
        case .listArticles(let limit, let offset):
            if let limit = limit { params["limit"] = limit }
            if let offset = offset { params["offset"] = offset }
            
        case .searchArticles(let query, let limit, let offset):
            params["search"] = query
            if let limit = limit { params["limit"] = limit }
            if let offset = offset { params["offset"] = offset }
            
         case .getArticleDetail:
             return nil
        }
        return params.isEmpty ? nil : params
    }
}
