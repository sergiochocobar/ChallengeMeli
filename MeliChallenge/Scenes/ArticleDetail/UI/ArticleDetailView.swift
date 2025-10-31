//
//  ArticleDetailView.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel
    let articleId: Int
    
    init(articleId: Int) {
        self.articleId = articleId
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(articleId: articleId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Cargando detalles...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if let article = viewModel.article {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            AsyncImage(url: URL(string: article.imageUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                case .failure:
                                    Image(systemName: "photo.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .padding(50)
                                default:
                                    ProgressView()
                                }
                            }
                        )
                        .clipped()
                    
                     VStack(alignment: .leading, spacing: 15) {
                         Text(article.title)
                             .font(.largeTitle)
                             .bold()
                         
                         HStack {
                             Text(article.newsSite.uppercased())
                                 .font(.caption.weight(.bold))
                                 .foregroundColor(.secondary)
                             
                             Spacer()
                             
                             // Fecha
                             if let date = article.publishedAt {
                                 Text(date.formatted(date: .long, time: .omitted))
                                     .font(.caption)
                                     .foregroundColor(.secondary)
                             }
                         }
                         
                         Divider()
                         
                         Text(article.summary)
                             .font(.body)
                         
                         if !article.authors.isEmpty {
                             SectionView(title: "Autores", items: article.authors)
                         }
                         
                         Divider()
                         
                         Link("Leer artículo completo en \(article.newsSite)", destination: URL(string: article.url)!)
                             .font(.headline)
                             .padding(.top, 8)
                         
                     }
                     .padding()
                     
                } else {
                    Text("Cargando...")
                        .onAppear {
                            viewModel.loadArticleDetail()
                        }
                }
            }
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadArticleDetail()
        }
    }
}

#Preview {
    NavigationView {
        ArticleDetailView(articleId: 33691)
    }
}
