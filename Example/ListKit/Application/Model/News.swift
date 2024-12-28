//
//  News.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

class News: Hashable {
    var id: String
    var title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
