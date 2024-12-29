//
//  LKFlatListDataSnapshot.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// A snapshot of the data for a flat list.
/// This struct conforms to `LKListDataSnapshot` and is available on iOS 13.0 or later.
@available(iOS 13.0, *)
public struct LKFlatListDataSnapshot<ItemIdentifierType>: LKListDataSnapshot
where
    ItemIdentifierType: Hashable, ItemIdentifierType: Sendable
{
    /// The underlying diffable data source snapshot.
    private var _current: NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>

    public init() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>()
        snapshot.appendSections([0])
        self._current = snapshot
    }

    /// Initializes a new snapshot with the given diffable data source snapshot.
    ///
    /// - Parameter snapshot: The diffable data source snapshot to initialize with.
    public init(_ snapshot: NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>) {
        self._current = snapshot
    }

    /// The diffable data source snapshot.
    public var diffableDataSourceSnapshot: NSDiffableDataSourceSnapshot<Int, ItemIdentifierType> {
        return _current
    }

    /// The number of items in the snapshot.
    public var numberOfItems: Int {
        return _current.numberOfItems
    }

    /// The identifiers of all of the items in the snapshot.
    public var itemIdentifiers: [ItemIdentifierType] {
        return _current.itemIdentifiers
    }

    /// Identifies the items reloaded by the changes to the snapshot.
    ///
    /// After you make updates to the snapshot, this property returns an array of
    /// identifiers corresponding to the sections that the view reloads when you
    /// apply the snapshot to your data source.
    @available(iOS 15.0, tvOS 15.0, *)
    public var reloadedItemIdentifiers: [ItemIdentifierType] {
        return _current.reloadedItemIdentifiers
    }

    /// Returns the index of the item in the snapshot with the specified
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the item in the snapshot.
    /// - Returns: The index of the item in the snapshot, or `nil` if the item with
    ///   the specified identifier doesn’t exist in the snapshot. This index value is 0-based.
    public func indexOfItem(_ identifier: ItemIdentifierType) -> Int? {
        return _current.indexOfItem(identifier)
    }

    public func itemIdentifier(_ indexPath: IndexPath) -> ItemIdentifierType? {
        let index = indexPath.item
        if index >= 0 && index < numberOfItems {
            return itemIdentifiers[index]
        }
        return nil
    }

    /// Adds the items with the specified identifiers to the specified section of the snapshot.
    ///
    /// - Parameters:
    ///   - identifiers: An array of identifiers specifying the items to add to the snapshot.
    public mutating func appendItems(_ identifiers: [ItemIdentifierType]) {
        _current.appendItems(identifiers, toSection: 0)
    }

    /// Inserts the specified items before the given item in the data snapshot.
    ///
    /// - Parameters:
    ///   - identifiers: An array of item identifiers to insert.
    ///   - beforeIdentifier: The item identifier before which the new items will be inserted.
    public mutating func insertItems(
        _ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType
    ) {
        _current.insertItems(identifiers, beforeItem: beforeIdentifier)
    }

    /// Inserts the specified items after the given item identifier.
    ///
    /// - Parameters:
    ///   - identifiers: An array of item identifiers to insert.
    ///   - afterIdentifier: The item identifier after which the new items should be inserted.
    public mutating func insertItems(
        _ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType
    ) {
        _current.insertItems(identifiers, afterItem: afterIdentifier)
    }

    /// Deletes the items with the specified identifiers from the current data snapshot.
    ///
    /// - Parameter identifiers: An array of item identifiers to be deleted.
    public mutating func deleteItems(_ identifiers: [ItemIdentifierType]) {
        _current.deleteItems(identifiers)
    }

    /// Deletes all items from the current data snapshot.
    public mutating func deleteAllItems() {
        _current.deleteAllItems()
    }

    ///
    /// Moves an item identified by `identifier` to a position before another item identified by `toIdentifier`.
    /// 
    /// - Parameters:
    ///   - identifier: The identifier of the item to move.
    ///   - toIdentifier: The identifier of the item before which the item should be moved.
    ///
    public mutating func moveItem(
        _ identifier: ItemIdentifierType, beforeItem toIdentifier: ItemIdentifierType
    ) {
        _current.moveItem(identifier, beforeItem: toIdentifier)
    }

    /// Moves an item identified by `identifier` to a position after the item identified by `toIdentifier`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the item to move.
    ///   - toIdentifier: The identifier of the item after which the item should be moved.
    public mutating func moveItem(
        _ identifier: ItemIdentifierType, afterItem toIdentifier: ItemIdentifierType
    ) {
        _current.moveItem(identifier, afterItem: toIdentifier)
    }

    /// Reloads the specified items in the data snapshot.
    ///
    /// This method updates the current state of the data snapshot by reloading the items
    /// identified by the given identifiers.
    ///
    /// - Parameter identifiers: An array of item identifiers that need to be reloaded.
    public mutating func reloadItems(_ identifiers: [ItemIdentifierType]) {
        _current.reloadItems(identifiers)
    }
}
