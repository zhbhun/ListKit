//
//  NewsCategoryViewModel.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import ListKit

class NewsCategoryViewModel: LKTabDataSource<NewsCategory> {
    @Published var status: DataStatus = .loading
    
    var materials: [String: NewsListViewModel] = [:]

    func load() async {
        do {
            status = .loading
            let categories = try await NewsService.shared.fetchCategories()

            categories.forEach { category in
                materials[category.id] = .init(category: category)
            }
            await materials[categories.first?.id ?? ""]?.load()

            var snapshot = snapshot()
            snapshot.appendItems(categories)
            apply(snapshot, mode: .reload)
            
            status = categories.isEmpty ? .empty : .success
        } catch {
            self.status = .failure(error)
        }
    }
}
