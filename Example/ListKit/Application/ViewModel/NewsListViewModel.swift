//
//  NewsListViewModel.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import ListKit

class NewsListViewModel: LKFlatListDataSource<News> {
    var category: NewsCategory
    var page: Int = 0
    var hasMore: Bool = true
    @Published var status: DataStatus = .loading

    init(category: NewsCategory) {
        self.category = category
    }

    func load(_ page: Int? = nil) async {
        let page = page ?? self.page
        do {
            status = .loading
            let news = try await NewsService.shared.fetchNews(page: page, pageSize: 30)
            if news.isEmpty {
                hasMore = false
            } else {
                var snapshot = snapshot()
                snapshot.appendItems(news)
                apply(snapshot, mode: .reload)
            }
            status = news.count <= 0 && page == 0 ? .empty : .success
            self.page = page + 1
        } catch {
            self.status = .failure(error)
        }
    }
}
