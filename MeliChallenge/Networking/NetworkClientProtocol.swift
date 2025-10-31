//
//  NetworkClientProtocol.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case badStatusCode(Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL es inválida."
        case .badStatusCode(let code):
            return "Error de servidor: \(code)"
        case .decodingFailed:
            return "No se pudo decodificar la respuesta."
        case .unknown(let error):
            return "Error desconocido: \(error.localizedDescription)"
        }
    }
}
