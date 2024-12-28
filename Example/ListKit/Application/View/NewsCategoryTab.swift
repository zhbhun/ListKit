//
//  NewsCategoryTab.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import ListKit
import UIKit

class NewsCategoryTab: LKTabLabel {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(_ item: NewsCategory, selected: Bool) {
        label.text = item.title
        label.textColor = .white
        select(item, selected: selected)
    }

    func select(_ item: NewsCategory, selected: Bool) {
        if selected {
            label.font = UIFont.boldSystemFont(ofSize: 16)
            contentView.backgroundColor = .black
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
            contentView.backgroundColor = .gray
        }
    }
}
