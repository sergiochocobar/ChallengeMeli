//
//  Endpoint.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var apiVersion: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    
    var url: URL? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}

extension Endpoint {
    var baseURL: String {
        return "https://api.spaceflightnewsapi.net"
    }
    
    var apiVersion: String {
        return "v4"
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = "/\(apiVersion)\(path)"
        
        if let parameters = parameters, method == .get {
            components?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        return components?.url
    }
}
