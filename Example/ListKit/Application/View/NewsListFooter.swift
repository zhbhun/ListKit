//
//  NewsListFooter.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import ListKit

class NewsListFooter: LKListReusableView {
    static let height: Double = 44
    
    let label: UILabel = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "loading..."
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
