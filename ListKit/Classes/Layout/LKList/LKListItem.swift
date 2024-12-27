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

    public init<ItemView>(_ render: @escaping Hander<ItemView>)
    where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        if #available(iOS 14.0, *) {
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
        } else {
            var registered = false
            self.handler = {
                (
                    _ listView: LKListView,
                    _ indexPath: IndexPath,
                    _ itemIdentifier: ItemIdentifier
                ) -> LKListItemView? in
                if !registered {
                    registered = true
                    listView.register(listItemView: ItemView.self)
                }
                guard
                    let cellView = listView.dequeueReusableCell(
                        withReuseIdentifier: "\(ItemView.self.hash())",
                        for: indexPath
                    ) as? ItemView
                else {
                    return .init()
                }
                render(cellView, indexPath, itemIdentifier)
                return cellView

            }
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
