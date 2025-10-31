//
//  ArticleListViewModel.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import Foundation
import Combine

@MainActor
class ArticleListViewModel: ObservableObject {
    
    @Published var articles: [ArticleModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let listArticlesUseCase: ListArticlesUseCaseProtocol
    private let searchArticlesUseCase: SearchArticlesUseCaseProtocol
    
    private var searchCancellable: AnyCancellable?
    
    private var currentOffset: Int = 0
    private let limit: Int = 20
    private var totalArticles: Int = 0
    private var canLoadMore: Bool = true
    
    init(searchArticlesUseCase: SearchArticlesUseCaseProtocol = SearchArticlesUseCase(),
         listArticlesUseCase: ListArticlesUseCaseProtocol = ListArticlesUseCase()) {
        
        self.searchArticlesUseCase = searchArticlesUseCase
        self.listArticlesUseCase = listArticlesUseCase
        
        searchCancellable = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.resetAndSearch()
            }
    }
    
    func initialLoad() {
        guard searchText.isEmpty else { return }
        loadArticles(isSearch: false, query: nil)
    }

    func loadMoreArticlesIfNeeded(currentItem item: ArticleModel?) {
        guard let item = item else {
            loadArticles(isSearch: !searchText.isEmpty, query: searchText.isEmpty ? nil : searchText)
            return
        }

        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -5)
        if articles.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadArticles(isSearch: !searchText.isEmpty, query: searchText.isEmpty ? nil : searchText)
        }
    }

    private func resetAndSearch() {
        articles = []
        currentOffset = 0
        totalArticles = 0
        canLoadMore = true
        loadArticles(isSearch: !searchText.isEmpty, query: searchText.isEmpty ? nil : searchText)
    }

    private func loadArticles(isSearch: Bool, query: String?) {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response: ArticleResponseModel
                if isSearch, let query = query, !query.isEmpty {
                    response = try await searchArticlesUseCase.execute(query: query, limit: limit, offset: currentOffset)
                } else {
                    response = try await listArticlesUseCase.execute(limit: limit, offset: currentOffset)
                }
                
                self.articles.append(contentsOf: response.articles)
                self.totalArticles = response.count
                self.currentOffset += response.articles.count
                self.canLoadMore = response.next != nil
                
            } catch {
                self.errorMessage = (error as? NetworkError)?.errorDescription ?? "Error inesperado."
            }
            self.isLoading = false
        }
    }
}
