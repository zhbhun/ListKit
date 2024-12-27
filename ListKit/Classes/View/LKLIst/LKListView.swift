//
//  LKListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public typealias LKListView = UICollectionView

extension UICollectionView {
    private struct AssociatedKeys {
        static var registeredView = "registeredView"
    }

    func register<ItemView: LKListItemView>(listItemView: ItemView.Type) {
        register(listItemView.self, forCellWithReuseIdentifier: "\(listItemView.hash())")
    }

    func register<SupplementaryView: LKListReusableView>(
        listSupplementaryView: SupplementaryView.Type,
        kind: String
    ) {
        register(
            listSupplementaryView.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: "\(listSupplementaryView.hash())"
        )
    }
}
