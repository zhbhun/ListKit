//
//  ZHListDataSnapshot.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct ZHFlatListDataSnapshot<ItemIdentifierType>: ZHListDataSnapshot where
ItemIdentifierType : Hashable, ItemIdentifierType : Sendable {
    private var _current: NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>
    
    public init() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>()
        snapshot.appendSections([0])
        self._current = snapshot
    }
    
    public init(_ snapshot: NSDiffableDataSourceSnapshot<Int, ItemIdentifierType>) {
        self._current = snapshot
    }
    
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
}

