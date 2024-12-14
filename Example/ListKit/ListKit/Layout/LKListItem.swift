//
//  LKListItem.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> LKListItemView?

    public typealias Hander<ItemView> = (
        _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
    ) -> Void where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable

    private let handler: LKListItem<ItemIdentifier>.Render

    public init(_ render: @escaping LKListItem<ItemIdentifier>.Render) {
        self.handler = render
    }

    public init<ItemView>(
        _ render: @escaping Hander<ItemView>
    ) where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> {
            (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        self.handler = {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: ItemIdentifier
            ) -> LKListItemView? in
            return listView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }

    public init(
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.handler = {
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

    public init(
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListItem<ItemIdentifier>]
    ) {
        self.handler = {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ itemIdentifier: ItemIdentifier
            ) -> UICollectionViewCell? in
            let key = resolve(indexPath.item)
            guard let item = items[key] else {
                return .init()
            }
            return item.render(listView, indexPath, itemIdentifier)
        }
    }

    public func render(
        _ listView: LKListView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
    )
        -> LKListItemView?
    {
        return handler(listView, indexPath, itemIdentifier)
    }
}
