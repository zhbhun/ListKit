//
//  ZHFlatListDataSource.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
open class ZHFlatListDataSource<ItemIdentifierType>: ZHListDataSource where
ItemIdentifierType : Hashable, ItemIdentifierType : Sendable {
    public typealias Handler = (_ snapshot: ZHFlatListDataSnapshot<ItemIdentifierType>, _ mode: ZHListApplyMode) -> Void
    
    private var _snapshot: ZHFlatListDataSnapshot<ItemIdentifierType> = ZHFlatListDataSnapshot<ItemIdentifierType>()
    private var _listeners: [Handler] = []

    public func onChange(_ listener: @escaping Handler) {
        _listeners.append(listener)
    }

    open func apply(
        _ snapshot: ZHFlatListDataSnapshot<ItemIdentifierType>,
        mode: ZHListApplyMode = .normal,
        completion: (() -> Void)? = nil
    ) {
        _snapshot = snapshot
        for listener in _listeners {
            listener(snapshot, mode)
        }
        completion?()
    }
    
    /// Returns a representation of the current state of the data
    ///
    /// - Returns: A snapshot containing item identifiers in the order that they appear in the UI.
    open func snapshot() -> ZHFlatListDataSnapshot<ItemIdentifierType> {
        return _snapshot
    }
    
    /// Returns an index for the item with the identifier you specify
    open func index(for itemIdentifier: ItemIdentifierType) -> Int? {
        return _snapshot.indexOfItem(itemIdentifier)
    }

    /// Returns an identifier for the item at the specified index path in the collection view.
    ///
    /// - Parameters:
    ///   - index: The index path of the item in the collection view.
    /// - Returns: The item's identifier, or nil if no item is found at the provided index path.
    ///
    /// This method is a constant time operation, O(1), which means you can look up an item identifier from its corresponding index path with no significant overhead.
    open func itemIdentifier(for index: Int) -> ItemIdentifierType? {
        return _snapshot.itemIdentifiers[index]
    }
    
    /// The number of items
    open var numberOfItems: Int {
        return _snapshot.numberOfItems
    }
}
