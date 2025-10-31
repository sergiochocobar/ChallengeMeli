//
//  ArticleDetailSectionView.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 31/10/2025.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text(title)
                .font(.title3)
                .bold()
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(item)
                    }
                }
            }
        }
    }
}
