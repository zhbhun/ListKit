//
//  NewsService.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

class NewsService {
    static let shared = NewsService()
    
    private init() {}
    
    // 获取 Category 列表
    func fetchCategories() async throws -> [NewsCategory] {
        // 模拟异步请求
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 延迟 1 秒

        // 模拟数据返回
        return [
            NewsCategory(id: "1", title: "Technology"),
            NewsCategory(id: "2", title: "Business"),
            NewsCategory(id: "3", title: "Sports"),
        ]
    }

    // 获取 News 列表
    func fetchNews(page: Int, pageSize: Int) async throws -> [News] {
        // 模拟异步请求
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 延迟 1 秒

        // 模拟数据生成
        let startIndex = page * pageSize
        let endIndex = startIndex + pageSize

        let allNews = (1...1000).map { News(id: "\($0)", title: "News Title \($0)") }
        let paginatedNews = Array(allNews[startIndex..<min(endIndex, allNews.count)])

        return paginatedNews
    }
}
