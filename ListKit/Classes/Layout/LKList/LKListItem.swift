//
//  LKListItem.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// A generic class representing an item in a list.
/// 
/// - Parameters:
///   - ItemIdentifier: The type used to uniquely identify the item.
public class LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// A typealias for a closure that renders an `LKListItemView`.
    ///
    /// - Parameters:
    ///   - listView: The `LKListView` that is requesting the view.
    ///   - indexPath: The `IndexPath` of the item.
    ///   - itemIdentifier: The identifier of the item to be rendered.
    /// - Returns: An optional `LKListItemView` for the specified item.
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> LKListItemView?

    /// A typealias for a handler closure that is used to configure a cell in a list.
    /// 
    /// - Parameters:
    ///   - cell: The cell to be configured, which conforms to `LKListItemView`.
    ///   - indexPath: The index path of the cell in the list.
    ///   - itemIdentifier: The identifier for the item, which conforms to `Hashable` and `Sendable`.
    public typealias Hander<ItemView> = (
        _ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
    ) -> Void where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable

    private let handler: LKListItem<ItemIdentifier>.Render

    /// Initializes a new instance of `LKListItem` with the specified render handler.
    /// 
    /// - Parameter render: A closure that defines how to render the `LKListItem`.
    /// - Returns: An initialized `LKListItem` object.
    public init(_ render: @escaping LKListItem<ItemIdentifier>.Render) {
        self.handler = render
    }

    /// Initializes a new instance of the `LKListItem` class with a render handler.
    /// - Parameters:
    ///   - render: A closure that takes an `ItemView`, `IndexPath`, and `ItemIdentifier` as parameters and returns void.
    /// - Important: 
    ///   - `ItemView` must conform to `LKListItemView`.
    ///   - `ItemIdentifier` must conform to both `Hashable` and `Sendable`.
    /// - Parameters:
    ///   - listView: The `LKListView` instance.
    ///   - indexPath: The index path of the item.
    ///   - itemIdentifier: The identifier of the item.
    /// - Returns: An optional `LKListItemView` instance.
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

    /// Initializes a new instance of the class with a resolve closure and a dictionary of items.
    /// 
    /// - Parameters:
    ///   - resolve: A closure that takes an index and returns a string key.
    ///   - items: A dictionary where the keys are strings and the values are `LKListItem` objects.
    /// 
    /// - Returns: A configured `UICollectionViewCell` or `nil` if the item is not found.
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

    /// Renders the list item view for the given parameters.
    ///
    /// - Parameters:
    ///   - listView: The `LKListView` instance that is requesting the view.
    ///   - indexPath: The `IndexPath` of the item in the list.
    ///   - itemIdentifier: The identifier for the item to be rendered.
    /// - Returns: An optional `LKListItemView` instance for the specified item.
    public func render(
        _ listView: LKListView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
    )
        -> LKListItemView?
    {
        return handler(listView, indexPath, itemIdentifier)
    }
}
