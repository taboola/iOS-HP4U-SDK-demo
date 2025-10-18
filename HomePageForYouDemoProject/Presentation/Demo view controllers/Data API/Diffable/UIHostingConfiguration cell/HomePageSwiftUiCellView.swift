//
//  HomePageSwiftUiCellView.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 18.08.2025.
//  Copyright © 2025 Taboola. All rights reserved.
//

import SwiftUI

struct HomePageSwiftUiCellView: View {
    let item: PublisherItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if let imageUrl = item.imageUrl {
                AsyncImage(url: imageUrl)
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    HomePageSwiftUiCellView(item: PublisherItem.mockItemWithImageUrl)
}
