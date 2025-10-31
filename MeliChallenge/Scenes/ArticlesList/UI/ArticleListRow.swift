//
//  ArticleListRow.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 29/10/2025.
//

import SwiftUI

struct ArticleListRow: View {
    let article: ArticleModel
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: article.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: 80, height: 80)
                         .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.3))
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                default:
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(article.newsSite)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(article.summary)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }
}
