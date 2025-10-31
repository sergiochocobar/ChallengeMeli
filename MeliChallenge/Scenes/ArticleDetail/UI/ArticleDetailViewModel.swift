//
//  ArticleDetailViewModel.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import Foundation
import Combine

@MainActor
class ArticleDetailViewModel: ObservableObject {
    
    @Published var article: ArticleModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getArticleDetailUseCase: GetArticleDetailUseCaseProtocol
    private let articleId: Int
    
    init(articleId: Int,
         getArticleDetailUseCase: GetArticleDetailUseCaseProtocol = GetArticleDetailUseCase()) {
        self.articleId = articleId
        self.getArticleDetailUseCase = getArticleDetailUseCase
    }
    
    func loadArticleDetail() {
        guard article == nil else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                self.article = try await getArticleDetailUseCase.execute(id: articleId)
            } catch {
                self.errorMessage = (error as? NetworkError)?.errorDescription ?? "Error cargando detalles."
            }
            self.isLoading = false
        }
    }
}
