//
//  LKFlatListDataSource.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

/// A data source class for flat list that conforms to `LKListDataSource`.
/// This class is available on iOS 13.0 and tvOS 13.0 or later.
@available(iOS 13.0, tvOS 13.0, *)
open class LKFlatListDataSource<ItemIdentifierType>: LKListDataSource
where
    ItemIdentifierType: Hashable, ItemIdentifierType: Sendable
{
    /// The current snapshot of the data source.
    private var current: LKFlatListDataSnapshot<ItemIdentifierType> = LKFlatListDataSnapshot<
        ItemIdentifierType
    >()

    /// A subject that publishes changes to the data source.
    public let change = PassthroughSubject<
        (LKFlatListDataSnapshot<ItemIdentifierType>, LKListApplyMode), Never
    >()
    
    public init() {}

    /// Applies a new snapshot to the data source.
    ///
    /// - Parameters:
    ///   - snapshot: The new snapshot to apply.
    ///   - mode: The mode in which to apply the snapshot. Default is `.normal`.
    ///   - completion: An optional completion handler to call when the apply is finished.
    open func apply(
        _ snapshot: LKFlatListDataSnapshot<ItemIdentifierType>,
        mode: LKListApplyMode = .normal,
        completion: (() -> Void)? = nil
    ) {
        self.current = snapshot
        self.change.send((snapshot, mode))
        completion?()
    }

    /// Returns a representation of the current state of the data
    ///
    /// - Returns: A snapshot containing item identifiers in the order that they appear in the UI.
    open func snapshot() -> LKFlatListDataSnapshot<ItemIdentifierType> {
        return current
    }

    /// Returns an index for the item with the identifier you specify
    open func indexOfItem(for itemIdentifier: ItemIdentifierType) -> Int? {
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

    /// An array of item identifiers in the current snapshot.
    open var itemIdentifiers: [ItemIdentifierType] {
        return current.itemIdentifiers
    }

    /// The number of items
    open var numberOfItems: Int {
        return current.numberOfItems
    }
}
