//
//  LKListCompositionalItem.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKListCompositionalItem<ItemIdentifier>: LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public override init(_ render: @escaping Render) {
        super.init(render)
    }

    public init<ItemView>(
        _ render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        super.init {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> LKListItemView? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return nil }
            return listView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
}

public class LKListCompositionalFlowItem<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let size: LKListDimension
    public let insets: NSDirectionalEdgeInsets

    public init<ItemView>(
        size: LKListDimension,
        insets: NSDirectionalEdgeInsets = .zero,
        render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: LKListItemView {
        self.size = size
        self.insets = insets
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        super.init {
            (
                _ listView: LKListView,
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
        size: LKListDimension,
        insets: NSDirectionalEdgeInsets = .zero,
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.size = size
        self.insets = insets
        super.init {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
            let key = resolve(indexPath.item)
            guard let item = items[key] else {
                return .init()
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

public class LKListCompositionalWaterfallItem<ItemIdentifier>: LKListCompositionalItem<
    ItemIdentifier
>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias RatioProvider = (_ item: ItemIdentifier) -> CGFloat

    public let ratio: LKCompositionalWaterfallItem<ItemIdentifier>.ItemRatioProvider

    public init<ItemView>(
        ratio: @escaping (_ item: ItemIdentifier) -> CGFloat,
        render: @escaping (
            _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        ) -> Void
    ) where ItemView: LKListItemView {
        self.ratio = ratio
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        super.init {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: any Hashable
            ) -> UICollectionViewCell? in
            guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
            return listView.dequeueConfiguredReusableCell(
                using: registration, for: indexPath, item: itemIdentifier)
        }
    }
}
