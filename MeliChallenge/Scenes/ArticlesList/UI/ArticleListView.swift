//
//  ArticleListView.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 28/10/2025.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Buscar artículo...", text: $viewModel.searchText)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    VStack {
                        Text("Tenemos un Problema")
                            .font(.title2)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                        Button("Reintentar") {
                            viewModel.initialLoad()
                        }
                        .padding(.top)
                    }
                    .padding()
                    Spacer()
                } else if viewModel.articles.isEmpty && !viewModel.searchText.isEmpty && !viewModel.isLoading {
                    Spacer()
                    Text("No se encontraron resultados para \"\(viewModel.searchText)\"")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(articleId: article.id)) {
                                ArticleListRow(article: article)
                            }
                            .onAppear {
                                viewModel.loadMoreArticlesIfNeeded(currentItem: article)
                            }
                        }
                        
                        if viewModel.isLoading && !viewModel.articles.isEmpty {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Space Flight News")
            .onAppear {
                if viewModel.articles.isEmpty {
                    viewModel.initialLoad()
                }
            }
        }
    }
}

#Preview {
    ArticleListView()
}
