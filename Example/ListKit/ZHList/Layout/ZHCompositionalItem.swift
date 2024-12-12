//
//  LKCompositionalItem.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class ZHCompositionalItem {
    public var didSelectAt: ZHListItemDidSelectHandler?

    public typealias Render = (
        _ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable
    ) -> UICollectionViewCell?

    private let _render: Render

    public init(_ render: @escaping Render) {
        _render = render
    }

    public init<ItemView, ItemIdentifier>(
        _ render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: ZHListCellView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        _render = {
            (
                _ listView: ZHListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return nil }
            return listView.dequeueConfiguredReusableCell(
                using: registration, for: indexPath, item: itemIdentifier)
        }
    }

    public func render(
        _ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable
    ) -> UICollectionViewCell? {
        return _render(listView, indexPath, itemIdentifier)
    }

    public func onDidSelectAt(_ handler: ZHListItemDidSelectHandler?) -> Self {
        didSelectAt = handler
        return self
    }
}

public class ZHCompositionalFlowItem<ItemIdentifier>: ZHCompositionalItem
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let size: ZHDimension
    public let insets: NSDirectionalEdgeInsets

    public init<ItemView>(
        size: ZHDimension,
        insets: NSDirectionalEdgeInsets = .zero,
        render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: ZHListCellView {
        self.size = size
        self.insets = insets
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        super.init {
            (
                _ listView: ZHListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return nil }
            return listView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }

    public init(
        size: ZHDimension,
        insets: NSDirectionalEdgeInsets = .zero,
        resolve: @escaping (_ index: Int) -> String,
        items: [String: ZHCompositionalItem]
    ) {
        self.size = size
        self.insets = insets
        super.init {
            (
                _ listView: ZHListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return nil }
            let key = resolve(indexPath.item)
            guard let item = items[key] else {
                return nil
            }
            return item.render(listView, indexPath, itemIdentifier)
        }
    }

    public func layout() -> [NSCollectionLayoutItem] {
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = insets
        return [item]
    }
}

public class LKCompositionalWaterfallItem<ItemIdentifier>: ZHCompositionalItem
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias ItemRatioProvider = (_ item: ItemIdentifier) -> CGFloat

    public let ratio: LKCompositionalWaterfallItem<ItemIdentifier>.ItemRatioProvider

    public init<ItemView>(
        ratio: @escaping (_ item: ItemIdentifier) -> CGFloat,
        render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: ZHListCellView {
        self.ratio = ratio
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        super.init {
            (
                _ listView: ZHListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
            return listView.dequeueConfiguredReusableCell(
                using: registration, for: indexPath, item: itemIdentifier)
        }
    }
}
