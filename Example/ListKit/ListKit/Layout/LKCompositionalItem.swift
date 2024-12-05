//
//  LKCompositionalItem.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKCompositionalItem {
    public var didSelectAt: ZHListItemDidSelectHandler?
    
    public init(
        kind: String = "",
        didSelectAt: ZHListItemDidSelectHandler? = nil
    ) {
        self.didSelectAt = didSelectAt
    }
    
    public func render(_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell? {
        fatalError("Subclasses must override `render`.")
    }
    
    public func onDidSelectAt(_ handler: ZHListItemDidSelectHandler?) -> Self {
        didSelectAt = handler
        return self
    }
}

public class LKCompositionalFlowItem<ItemIdentifier>: LKCompositionalItem where
ItemIdentifier : Hashable, ItemIdentifier : Sendable {
    public let size: LKDimension
    public let contentInsets: NSDirectionalEdgeInsets

    private let _render: (_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell?
    
    public init<ItemView>(
        size: LKDimension,
        contentInsets: NSDirectionalEdgeInsets = .zero,
        render: @escaping (_ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier) -> Void
    ) where ItemView: ZHListCellView {
        self.size = size
        self.contentInsets = contentInsets
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> { (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        self._render = { (
            _ listView: ZHListView,
            _ indexPath: IndexPath,
            _ itemIdentifier: any Hashable
        ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return nil }
            return listView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
        super.init()
    }

    public override func render(_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell? {
        return _render(listView, indexPath, itemIdentifier)
    }
    
    public func resolve() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = contentInsets
        return item
    }
}


public class LKCompositionalWaterfallItem<ItemIdentifier>: LKCompositionalItem  where
ItemIdentifier : Hashable, ItemIdentifier : Sendable {
    public typealias ItemRatioProvider = (_ item: ItemIdentifier) -> CGFloat
    
    public let ratio: LKCompositionalWaterfallItem<ItemIdentifier>.ItemRatioProvider
    
    private let _render: (_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell?
    
    public init<ItemView>(
        ratio: @escaping (_ item: ItemIdentifier) -> CGFloat,
        render: @escaping (_ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier) -> Void
    ) where ItemView: ZHListCellView {
        self.ratio = ratio
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> { (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        self._render =  { (
            _ listView: ZHListView,
            _ indexPath: IndexPath,
            _ itemIdentifier: any Hashable
        ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
            return listView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
        super.init()
    }
    
    public override func render(_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell? {
        return _render(listView, indexPath, itemIdentifier)
    }

}
