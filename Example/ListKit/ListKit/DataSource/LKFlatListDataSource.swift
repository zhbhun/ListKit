//
//  ZHFlatListDataSource.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
open class LKFlatListDataSource<ItemIdentifierType>: LKListDataSource
where
    ItemIdentifierType: Hashable, ItemIdentifierType: Sendable
{
    public typealias Handler = (
        _ snapshot: LKFlatListDataSnapshot<ItemIdentifierType>, _ mode: LKListApplyMode
    ) -> Void

    private var current: LKFlatListDataSnapshot<ItemIdentifierType> = LKFlatListDataSnapshot<
        ItemIdentifierType
    >()
    private var listeners: [Handler] = []

    public func onChange(_ listener: @escaping Handler) {
        listeners.append(listener)
    }

    open func apply(
        _ snapshot: LKFlatListDataSnapshot<ItemIdentifierType>,
        mode: LKListApplyMode = .normal,
        completion: (() -> Void)? = nil
    ) {
        self.current = snapshot
        for listener in listeners {
            listener(snapshot, mode)
        }
        completion?()
    }

    /// Returns a representation of the current state of the data
    ///
    /// - Returns: A snapshot containing item identifiers in the order that they appear in the UI.
    open func snapshot() -> LKFlatListDataSnapshot<ItemIdentifierType> {
        return current
    }

    /// Returns an index for the item with the identifier you specify
    open func index(for itemIdentifier: ItemIdentifierType) -> Int? {
        return current.indexOfItem(itemIdentifier)
    }

    /// Returns an identifier for the item at the specified index path in the collection view.
    ///
    /// - Parameters:
    ///   - index: The index path of the item in the collection view.
    /// - Returns: The item's identifier, or nil if no item is found at the provided index path.
    ///
    /// This method is a constant time operation, O(1), which means you can look up an item identifier from its corresponding index path with no significant overhead.
    open func itemIdentifier(for index: Int) -> ItemIdentifierType? {
        guard index >= 0, index < current.itemIdentifiers.count else {
            return nil
        }
        return current.itemIdentifiers[index]
    }

    /// The number of items
    open var numberOfItems: Int {
        return current.numberOfItems
    }
}
