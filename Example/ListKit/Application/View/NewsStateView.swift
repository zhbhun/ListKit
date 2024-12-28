//
//  NewsStateView.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// 加载中、加载失败、空数据等
class NewsStateView: UIView {
    let label: UILabel = .init()

    init() {
        super.init(frame: .zero)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        update(status: .loading)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(status: DataStatus) {
        switch status {
        case .loading:
            label.text = "loading..."
        case .empty:
            label.text = "no data"
        case .failure(let error):
            label.text = error.localizedDescription
        case .success:
            isHidden = true
        }
    }
}
